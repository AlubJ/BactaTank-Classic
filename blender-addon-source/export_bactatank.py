# ##### BEGIN GPL LICENSE BLOCK #####
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software Foundation,
#  Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#
# ##### END GPL LICENSE BLOCK #####

# Global Imports
from struct import pack
import bpy

# Global Variables Defines
engine = "PCGHG"
version = 0.5

# Check Blender version
bVersion = bpy.app.version
b41_up = bVersion[0] == 4 and bVersion[1] >= 1  # Blender 4.1 and up

# Common Functions Here!
def mesh_triangulate(me):
    import bmesh
    bm = bmesh.new()
    bm.from_mesh(me)
    bmesh.ops.triangulate(bm, faces=bm.faces)
    bm.to_mesh(me)
    bm.free()

def array_index(array, value):
    i = 0
    for a in array:
        if a == value:
            return i
        i+=1
    
    return -1

# Vertex Class
class Vertex:
    position = None     # These will always exist
    normal = None       # These will always exist
    tangent = None      # This will always be None, we never need to export this.
    bitangent = None    # This will always be None, we never need to export this.
    colourSet1 = None   # These might exist depending on the situation
    colourSet2 = None   # These might exist depending on the situation
    uvSet1 = None       # These might exist depending on the situation
    uvSet2 = None       # These might exist depending on the situation
    blendIndices = None # These might exist depending on the situation
    blendWeights = None # These might exist depending on the situation
    index = None        # The index of the vertex
     
    # Print Method
    def __str__(self):
        return "{ position: " + self.position + ", normal: " + self.normal + ", uvSet1: " + self.uvSet1 + " }"

def find_in_vertices(vertices, value):
    for i, v in enumerate(vertices):
        if v.position[0] == value[0] and v.position[1] == value[1] and v.position[2] == value[2]:
            return i

def find_all_in_vertices(vertices, value):
    indices = [  ]
    for i, v in enumerate(vertices):
        #print(str(v.position[0]) + " " + str(v.position[1]) + " " + str(v.position[2]) + " | " + str(value[0]) + " " + str(value[1]) + " " + str(value[2]))
        if round(v.position[0], 7) == round(value[0], 7) and round(v.position[1], 7) == round(value[2], 7) and round(v.position[2], 7) == round(value[1], 7):
            indices.append(v.index)
    return indices

# Evaluate Vertex Attributes
def evaluate_vertex_attributes(vertices):
    # Get the first vertex
    vertex = vertices[0]

    # Create Attributes Array
    attributes = [ "Position", "Normal" ]

    # Check Attributes
    if vertex.colourSet1 != None:
        attributes.append("ColourSet1")
    if vertex.colourSet2 != None:
        attributes.append("ColourSet2")
    if vertex.uvSet1 != None:
        attributes.append("UVSet1")
    if vertex.uvSet2 != None:
        attributes.append("UVSet2")
    if vertex.tangent != None:
        attributes.append("Tangents")
    if vertex.blendIndices != None:
        attributes.append("BlendIndices")
    if vertex.blendWeights != None:
        attributes.append("BlendWeights")
    
    # Return Attributes
    return attributes

# Prepare Mesh
def prepare_meshes(context, meshes, global_matrix = None, apply_moderfiers = True):
    # Imports
    import bmesh
    import bpy

    # Create Depsgraph To Apply All Moderfiers
    depsgraph = context.evaluated_depsgraph_get()

    # Create a new BMesh
    bm = bmesh.new()

    # Try to apply moderfers here
    for mesh in meshes:
        if apply_moderfiers:
            mesh_evaluated = mesh.evaluated_get(depsgraph)
        else:
            mesh_evaluated = mesh

        try:
            me = mesh_evaluated.to_mesh()
        except RuntimeError:
            continue

        # Transform the mesh to the objects matrix
        me.transform(mesh.matrix_world)
        bm.from_mesh(me)
        mesh_evaluated.to_mesh_clear()

    test_layer = bm.verts.layers.int.get('index') or bm.verts.layers.int.new('index')
    for i, vert in enumerate(bm.verts):
        vert[test_layer] = i

    # Create Temporary Mesh (This is what is returned)
    mesh = bpy.data.meshes.new("Temporary BactaTank Classic v0.3 Mesh")
    bm.to_mesh(mesh)
    bm.free()

    # Apply the global matrix
    if global_matrix is not None:
        mesh.transform(global_matrix)

    # Calculate the normals here
    if not b41_up:
        mesh.calc_normals_split()
    mesh.calc_tangents()

    # And we flip the normals due to the left-handed coordinate system that TtGames uses.
    mesh.flip_normals()

    # Triangulate the mesh
    mesh_triangulate(mesh)

    # Return The Prepared Mesh
    return mesh

# Generate Blend
def generate_blend(mesh, vertex, boneNames, bindmap):
    # Get Vertex Groups
    mod_groups = [group for group in vertex.groups if mesh.vertex_groups[group.group].name in boneNames]
    groups = sorted(mod_groups, key=lambda group: group.weight)[0:3]

    # Get Sum Of Bone Influences
    s = sum([g.weight + 0.0001 for g in groups])

    # Debug Information
    #print([g.weight for g in groups])
    #print(s)

    # Create Default Blend Index
    blendIndex = [-1,-1,-1,-1]
    blendWeight = [0,0,0,255]

    # Create Default Blend Weight
    for index, group in enumerate(groups):              # 3 bone weights max!
        vg_index = group.group                          # Index of the vertex group
        vg_name = mesh.vertex_groups[vg_index].name      # Name of the vertex group#
        w = group.weight/s*255
        blendIndex[index] = bindmap[vg_name]
        blendWeight[index] = int(w if w <= 255 else 255)  # clamp to ubyte range!
    
    # Return Blend
    return blendIndex, blendWeight

# Write Specific Blocks Of Data
# Header Block
# This writes the header of the bmesh file. Since we can export either to PCGHG or NXG-LIJ2, we can throw the engine as a global variable.
def write_header(buffer):
    buffer.extend(bytearray("BactaTankMesh\0",'utf-8'))
    buffer.extend(bytearray(engine + "\0",'utf-8'))
    buffer.extend(pack("f", version))

# Bone Names Block
# This writes all the bone names into the mesh file, specifically for skinning data as the mesh will autoparent itself to the armature that is in the scene.
def write_bones(buffer, armature = None):
    buffer.extend(bytearray("Bones\0",'utf-8'))
    if armature != None:
        buffer.extend(pack("i", len(armature.data.bones))) # Bone Count
        for bone in armature.data.bones:
            buffer.extend(bytearray(bone.name + "\0",'utf-8'))
    else:
        buffer.extend(pack("i", 0)) # Bone Count (0 if no armature is present)

# Mesh Block
# This is where we write the mesh data into the file. Meshes can vary in what attributes they have in them, so we keep track of that by defining what the vertices contain.
def write_mesh(buffer, vertices, triangles, shapeKeys, linkedBones, isStrip = True):
    # Write Mesh Tag
    buffer.extend(bytearray("Mesh\0",'utf-8'))

    # Mesh Vertex Count
    buffer.extend(pack("I", len(vertices)))

    # Mesh Triangle Count
    if isStrip:
        buffer.extend(pack("I", len(triangles) - 2))
    else:
        buffer.extend(pack("I", len(triangles)))

    # Mesh Linked Bones
    buffer.extend(pack("%db" % len(linkedBones), *linkedBones))

    # Mesh Attributes Tag
    buffer.extend(bytearray("MeshAttributes\0",'utf-8'))

    # Evaluate Vertex Attributes
    attributes = evaluate_vertex_attributes(vertices)

    # Write Attribute Count
    buffer.extend(pack("I", len(attributes)))

    # Write Attributes
    for attribute in attributes:
        buffer.extend(bytearray(attribute + "\0",'utf-8'))

    # Vertices
    buffer.extend(bytearray("Vertices\0",'utf-8'))
    
    # Vertex Positions
    if "Position" in attributes:
        # Position Tag
        buffer.extend(bytearray("Position\0",'utf-8'))

        # Position Vertices
        for vertex in vertices:
            # Position
            buffer.extend(pack("f", -vertex.position[0]))
            buffer.extend(pack("f", vertex.position[1]))
            buffer.extend(pack("f", vertex.position[2]))

    # Vertex Normals (Change to 3f)
    if "Normal" in attributes:
        # Normal Tag
        buffer.extend(bytearray("Normal\0",'utf-8'))
        
        # Normals
        for vertex in vertices:
            # Normal
            buffer.extend(pack("B", int((float(vertex.normal[0]) + 1) * 127.5)))
            buffer.extend(pack("B", 255 - int((float(vertex.normal[1]) + 1) * 127.5)))
            buffer.extend(pack("B", 255 - int((float(vertex.normal[2]) + 1) * 127.5)))
            buffer.extend(pack("B", 0))

    # Vertex Colour Set 1
    if "ColourSet1" in attributes:
        # Colour Tag
        buffer.extend(bytearray("ColourSet1\0",'utf-8'))
        
        # Colour
        for vertex in vertices:
            # Colour
            buffer.extend(pack("B", 127))
            buffer.extend(pack("B", 127))
            buffer.extend(pack("B", 127))
            buffer.extend(pack("B", 127))
    
    # Vertex Colour Set 2
    if "ColourSet2" in attributes:
        # Colour Tag
        buffer.extend(bytearray("ColourSet2\0",'utf-8'))
        
        # Colour
        for vertex in vertices:
            # Colour
            buffer.extend(pack("B", 127))
            buffer.extend(pack("B", 127))
            buffer.extend(pack("B", 127))
            buffer.extend(pack("B", 127))
    
    # Vertex UV Set 1
    if "UVSet1" in attributes:
        # UV Tag
        buffer.extend(bytearray("UVSet1\0",'utf-8'))
        
        # UVs
        for vertex in vertices:
            # UV Coords
            buffer.extend(pack("<2f", *vertex.uvSet1))
    
    # Vertex UV Set 2
    if "UVSet2" in attributes:
        # UV Tag
        buffer.extend(bytearray("UVSet2\0",'utf-8'))
        
        # UVs
        for vertex in vertices:
            # UV Coords
            buffer.extend(pack("<2f", *vertex.uvSet2))

    # Vertex Tangents
    if "Tangents" in attributes:
        # Tangents Tag
        buffer.extend(bytearray("Tangents\0",'utf-8'))
        
        # Tangents
        for vertex in vertices:
            # Tangents
            buffer.extend(pack("B", vertex.tangent[0]))
            buffer.extend(pack("B", 255 - vertex.tangent[1]))
            buffer.extend(pack("B", 255 - vertex.tangent[2]))
            buffer.extend(pack("B", vertex.tangent[3]))

    # Vertex Blend Indices
    if "BlendIndices" in attributes:
        # Blend Indices Tag
        buffer.extend(bytearray("BlendIndices\0",'utf-8'))

        # Blend Indices
        for vertex in vertices:
            # Position
            buffer.extend(pack("4b", *vertex.blendIndices))

    # Vertex Blend Weights
    if "BlendWeights" in attributes:
        # Blend Weights Tags
        buffer.extend(bytearray("BlendWeights\0",'utf-8'))

        # Blend Weights
        for vertex in vertices:
            # Position
            buffer.extend(pack("4B", *vertex.blendWeights))

    # Triangles Tag
    buffer.extend(bytearray("Trianges\0",'utf-8'))

    # Triangles
    for triangle in triangles:
        buffer.extend(pack("h", triangle))

    # Dynamic Buffers Tag
    buffer.extend(bytearray("Dynamic Buffers\0",'utf-8'))

    # Dynamic Buffer Count
    buffer.extend(pack("I", len(shapeKeys)))

    # Write Dynamic Buffers
    for dynamicBuffer in shapeKeys:
        for i, vertex in enumerate(vertices):
            buffer.extend(pack("f", -dynamicBuffer[i][0]))
            buffer.extend(pack("f", dynamicBuffer[i][1]))
            buffer.extend(pack("f", dynamicBuffer[i][2]))

def export_pcghg(vertices, triangles, shapeKeys, linkedBones, armature, filepath):
    # Model Bytes
    modelBytes = bytearray()

    # Write Header
    write_header(modelBytes)

    # Write Bones
    write_bones(modelBytes, armature)

    # Write Mesh
    write_mesh(modelBytes, vertices, triangles, shapeKeys, linkedBones)

    # Save File Here
    with open(filepath, "wb") as file:
        file.write(modelBytes)

def export_nxg(verts, boneInd, boneWeights, boneUse, faces, strips, mesh_verts, filepath):
    from struct import pack

    # Model Bytes
    modelBytes = bytearray()

    # Header
    modelBytes.extend(bytearray("BactaTank\0",'utf-8'))
    modelBytes.extend(bytearray("NXG\0",'utf-8'))
    modelBytes.extend(pack(">f", 0.1))

    # Material data probably
    #modelBytes.extend(bytearray("Materials\0",'utf-8'))
    #modelBytes.extend(pack(">i", 0)) # Material Count
    #fw(pack("I", 33556745))

    #modelBytes.extend(bytearray("Bones\0",'utf-8'))
    #modelBytes.extend(pack(">i", 0)) # Bone Count

    # Mesh Data
    modelBytes.extend(bytearray("Meshes\0",'utf-8'))
    modelBytes.extend(pack(">i", 1)) # Mesh Count

    # Mesh Data
    modelBytes.extend(bytearray("MeshData\0",'utf-8'))
    modelBytes.extend(pack(">I", len(faces)))
    modelBytes.extend(pack(">I", len(verts)))
    modelBytes.extend(pack("8b", *boneUse))
    modelBytes.extend(bytearray("MeshAttributes\0",'utf-8'))
    modelBytes.extend(pack(">I", 6))
    modelBytes.extend(bytearray("Position\0",'utf-8'))
    modelBytes.extend(bytearray("Normal\0",'utf-8'))
    modelBytes.extend(bytearray("Colour\0",'utf-8'))
    modelBytes.extend(bytearray("UV\0",'utf-8'))
    modelBytes.extend(bytearray("BlendIndices\0",'utf-8'))
    modelBytes.extend(bytearray("BlendWeights\0",'utf-8'))

    # Vertex buffer
    # ---------------------------

    modelBytes.extend(bytearray("VertexBuffer\0",'utf-8'))
    modelBytes.extend(bytearray("Position\0",'utf-8'))

    for index, normal, uv_coords in verts:
        # Position
        modelBytes.extend(pack(">f", -mesh_verts[index].co[0]))
        modelBytes.extend(pack(">f", mesh_verts[index].co[1]))
        modelBytes.extend(pack(">f", mesh_verts[index].co[2]))

    modelBytes.extend(bytearray("Normal\0",'utf-8'))
    
    for index, normal, uv_coords in verts:
        # Normal
        modelBytes.extend(pack("B", int((float(normal[0]) + 1) * 127.5)))
        modelBytes.extend(pack("B", 255 - int((float(normal[1]) + 1) * 127.5)))
        modelBytes.extend(pack("B", 255 - int((float(normal[2]) + 1) * 127.5)))
        modelBytes.extend(pack("B", 255))

    modelBytes.extend(bytearray("Colour\0",'utf-8'))
    
    # TODO: Allow for colours to be taken from the actual model in blender
    for index, normal, uv_coords in verts:
        # Colour
        modelBytes.extend(pack("B", 127))
        modelBytes.extend(pack("B", 127))
        modelBytes.extend(pack("B", 127))
        modelBytes.extend(pack("B", 127))
        
    modelBytes.extend(bytearray("UV\0",'utf-8'))
    
    for index, normal, uv_coords in verts:
        # UV Coords
        modelBytes.extend(pack(">2e", *uv_coords))

    modelBytes.extend(bytearray("BlendIndices\0",'utf-8'))

    for index in verts:
        # Position
        modelBytes.extend(pack("4b", *boneInd[index[0]]))

    modelBytes.extend(bytearray("BlendWeights\0",'utf-8'))

    for index in verts:
        # Position
        modelBytes.extend(pack("4B", *boneWeights[index[0]]))

    # Index buffer
    # ---------------------------
    
    modelBytes.extend(bytearray("IndexBuffer\0",'utf-8'))
    modelBytes.extend(pack(">I", len(faces)*6))

    for pf in faces:
        modelBytes.extend(pack(">3h", *pf))

    with open(filepath, "wb") as file:
        file.write(modelBytes)

def generate_vertex_data(mesh, obj, armature, export_skinning, export_shape_keys, export_version, context):
    # Imports
    import bpy
    import bmesh
    import mathutils
    from . import tristrip

    # Helper Functions
    def rvec3d(v):
        return round(v[0], 6), round(v[1], 6), round(v[2], 6)
    def rvec2d(v):
        return round(v[0], 6), round(v[1], 6)
    
    # Create Vertex Arrays
    vertices = [  ]
    tempVertices = [  ]

    # Create UV Layers Array (and cap it to 2)
    uvLayers = [ None, None ]
    
    # UV Layers Loop
    for i, layer in enumerate(mesh.uv_layers):
        if i > 1:
            continue
        uvLayers[i] = layer.data

    # Create Colour Layers Array (and cap it to 2)
    colourLayers = [  ]
    
    # Vertex Colour Layers Loop
    for i, layer in enumerate(mesh.vertex_colors):
        if i > 1:
            continue
        colourLayers.append(layer)
    
    # Create Armature Bind Map
    bindmap = {}
    boneNames = None
    if armature != None and export_skinning:
        boneNames = armature.data.bones.keys()
        sample_bone_ind = 0
        for node in armature.data.bones:
            bindmap[node.name] = sample_bone_ind
            sample_bone_ind = sample_bone_ind + 1

    # Get The Meshes Actual Vertices
    meshVertices = mesh.vertices
    
    # Create a vertex dictionary, used for generating correct looking normals
    vdict = [{} for i in range(len(meshVertices))]

    # Create faces array (Triangles before stripification)
    faces = [[] for f in range(len(mesh.polygons))]

    # Linked Bones
    linkedBones = [-1] * 8

    # Pre-generate Vertex Array
    for v in meshVertices:
        vertex = Vertex()

        # Set Position Value
        vertex.position = v.co[:]

        # Set Index
        vertex.index = v.index

        # Only if we want to export skinning
        if export_skinning and armature != None:
            # Get Skinning Data
            blendIndices, blendWeights = generate_blend(obj, v, boneNames, bindmap)

            # Set Skinning Data
            vertex.blendIndices = blendIndices
            vertex.blendWeights = blendWeights

        # Append Vertex To Vertices
        tempVertices.append(vertex)
    
    # Only if we want to export skinning
    if export_skinning and armature != None:
        # Generate Linked Bones
        for v in tempVertices:
            for blendIndex in v.blendIndices:
                if array_index(linkedBones, blendIndex) == -1:
                    for i in range(7):
                        if linkedBones[i] == -1:
                            linkedBones[i] = blendIndex
                            break

        # Apply Relative Blend Indices To The Blend Indices
        for v in tempVertices:
            for i, blendIndex in enumerate(v.blendIndices):
                if blendIndex != -1:
                    tempVertices[v.index].blendIndices[i] = array_index(linkedBones, blendIndex)

    # Create a map from loop indices to exported vertex indices (for shape keys)
    loop_map = {}

    # Store averaged tangents per vertex
    vertex_tangents = [mathutils.Vector((0.0, 0.0, 0.0)) for _ in range(len(mesh.vertices))]
    vertex_tangent_counts = [0 for _ in range(len(mesh.vertices))]

    for poly in mesh.polygons:
        for loop_index in poly.loop_indices:
            loop = mesh.loops[loop_index]
            vidx = loop.vertex_index
            vertex_tangents[vidx] += loop.tangent
            vertex_tangent_counts[vidx] += 1

    for i, count in enumerate(vertex_tangent_counts):
        if count > 0:
            vertex_tangents[i].normalize()

    # This is where we get the normals, uvLayers, and colourLayers (when I add them)
    vert_count = 0
    for i, f in enumerate(mesh.polygons):
        # Check if face is smooth
        smooth = f.use_smooth
        if not smooth:
            normal = f.normal[:]
            normal_key = rvec3d(normal)

        # Generate UV Layers
        uvSet1 = [  ]
        uvSet2 = [  ]

        # UV Set 1
        if uvLayers[0] != None:
            uvSet1 = [
                uvLayers[0][l].uv[:]
                for l in range(f.loop_start, f.loop_start + f.loop_total)
            ]
        if uvLayers[1] != None:
            uvSet2 = [
                uvLayers[1][l].uv[:]
                for l in range(f.loop_start, f.loop_start + f.loop_total)
            ]

        # Faces for something??
        pf = faces[i]

        # Loop Face Vertices
        for j, vidx in enumerate(f.vertices):
            # Get Vertex Normal
            v = meshVertices[vidx]
            if smooth:
                normal = v.normal[:]
                normal_key = rvec3d(normal)

            # Get UVs for Both Layers
            uvcoord1 = None
            uvcoord2 = None
            if len(uvSet1) > 0:
                #print(uvSet1[j])
                uvcoord1 = uvSet1[j][0], 1-uvSet1[j][1]
                uvcoord_key = rvec2d(uvcoord1)
            if len(uvSet2) > 0:
                uvcoord2 = uvSet2[j][0], 1-uvSet2[j][1]
                uvcoord_key = rvec2d(uvcoord2)

            # Set Keys
            key = normal_key, uvcoord_key,

            # Vertex Dictionary Item
            vdict_local = vdict[vidx]
            pf_vidx = vdict_local.get(key)  # Will be None initially

            # As long as face is valid
            if pf_vidx is None:  # Same as vdict_local.has_key(key)
                pf_vidx = vdict_local[key] = vert_count

                # Create New Vertex
                vertex = Vertex()
                vertex.index = vidx

                # Apply Position
                vertex.position = tempVertices[vidx].position

                # Apply Normal
                vertex.normal = normal

                # Apply UV Sets
                vertex.uvSet1 = uvcoord1
                vertex.uvSet2 = uvcoord2

                # Apply Blend
                vertex.blendIndices = tempVertices[vidx].blendIndices
                vertex.blendWeights = tempVertices[vidx].blendWeights

                # Apply tangent
                loop_index = f.loop_start + j
                loop = mesh.loops[loop_index]
                tangent_vec = vertex_tangents[vidx]
                bitangent_sign = loop.bitangent_sign
                vertex.tangent = [
                    int((c + 1.0) * 127.5) for c in tangent_vec
                ] + [int((bitangent_sign + 1.0) * 127.5)]

                # Add to Vertices
                vertices.append(vertex)

                # Increase Vertex Count
                vert_count += 1

            pf.append(pf_vidx)

            loop_index = f.loop_start + j
            loop_map[loop_index] = pf_vidx
    
    # Generate Shape Keys
    shapeKeys = []

    # Check if mesh has shape keys
    if obj.data.shape_keys != None and export_shape_keys != False:
        originalShapeKeys = obj.data.shape_keys.key_blocks
        
        basisShapeKey = []
        for key in originalShapeKeys:
            #print(key.name)
            if key.name == "Basis":
                for v in key.data:
                    basisShapeKey.append([v.co.x, v.co.y, v.co.z])
            else:
                shapeKey = [[0, 0, 0] for _ in vertices]
                # For each loop that maps to a unique exported vertex
                for loop_idx, vert_idx in loop_map.items():
                    sk_vert = key.data[mesh.loops[loop_idx].vertex_index]
                    basis_vert = basisShapeKey[mesh.loops[loop_idx].vertex_index]

                    delta = [
                        sk_vert.co.x - basis_vert[0],
                        sk_vert.co.y - basis_vert[1],
                        sk_vert.co.z - basis_vert[2],
                    ]
                    shapeKey[vert_idx] = delta
                shapeKeys.append(shapeKey)

    # Stripify if the version is PCGHG
    #print(len(vertices))
    if export_version == "pcghg":
        triangles = tristrip.stripify(faces, stitchstrips=True)[0]
    else:
        triangles = faces
    #print(triangles)
    
    # Return Vertices and Triangles
    return vertices, triangles, shapeKeys, linkedBones


def exportMesh(
    context,
    filepath="",
    export_skinning=False,
    export_shape_keys=False,
    use_selection=False,
    use_mesh_modifiers=True,
    export_version=None,
    global_matrix=None,
):
    import time
    import bpy
    import bmesh

    # Timer
    t = time.time()

    # Set To Object Mode
    if bpy.ops.object.mode_set.poll():
        bpy.ops.object.mode_set(mode='OBJECT')

    # Get Exportable Things
    objects = context.scene.objects

    # Get All Armatures
    armatures = [a for a in objects if a.type == 'ARMATURE']
    armature = None
    if len(armatures) > 0:
        armature = armatures[0]
    
    # Get All Meshes (Selected Only If Enabled)
    if use_selection:
        meshes = [obj for obj in bpy.context.selected_objects if obj.type == 'MESH']
    else:
        meshes = [o for o in objects if o.type == 'MESH']
    
    # Get First Mesh For Working With Shapekeys
    obj = None
    if len(meshes) > 0:
        obj = meshes[0]
        
    
    # Prepare Mesh
    mesh = prepare_meshes(context, meshes, global_matrix, use_mesh_modifiers)

    # Generate Vertex Data
    vertices, triangles, shapeKeys, linkedBones = generate_vertex_data(mesh, obj, armature, export_skinning, export_shape_keys, export_version, context)

    # Debug
    #for v in vertices:
        #print(v.position)
        #print(v.normal)
        #print(v.uvSet1)
        #print("")

    # Export!
    if export_version == "pcghg":
        export_pcghg(vertices, triangles, shapeKeys, linkedBones, armature, filepath)
    #elif export_version == "nxglij2":
        #export_nxg(ttm_verts, ttm_boneInd, ttm_weights, ttm_boneUse, ttm_faces, ttm_strips, mesh_verts, filepath)

    # Delete The Temporary Mesh
    bpy.data.meshes.remove(mesh)

    # Print Export Time
    t_delta = time.time() - t
    print(f"Export completed {filepath!r} in {t_delta:.3f}")
