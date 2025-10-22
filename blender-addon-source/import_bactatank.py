# Import Struct Unpack and Unpack From
from struct import unpack, unpack_from

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
    if vertex.blendIndices != None:
        attributes.append("BlendIndices")
    if vertex.blendWeights != None:
        attributes.append("BlendWeights")
    
    # Return Attributes
    return attributes

def find_in_vertices(vertices, value):
    for i, v in enumerate(vertices):
        if v.position[0] == value[0] and v.position[1] == value[1] and v.position[1] == value[1]:
            return i

# Read String Function
def readString(data, offset):
    string = ""
    currentCharacter = unpack_from("c", data, offset)[0]
    string += currentCharacter.decode("utf-8")
    offset += 1
    while True:
        if (currentCharacter == b"\x00"):
            break
        else:
            currentCharacter = unpack_from("c", data, offset)[0]
            offset += 1
            string += currentCharacter.decode("utf-8")
        
    return [string[:-1], offset]

def array_index(array, value):
    i = 0
    for a in array:
        if a == value:
            return i
        i+=1
    
    return -1

# Read in the header file, and check the version. We return the magic to determine what thing we are importing.
def read_header(buffer, offset):
    # BactaTankMesh and PCGHG
    magic = readString(buffer, offset) # BactaTankMesh
    offset = magic[1]
    version = readString(buffer, offset) # PCGHG
    offset = version[1]

    # Check version is 0.4
    version = unpack_from("f", buffer, offset)[0]
    if round(version, 1) != 0.4 and round(version, 1) != 0.5:
        raise Exception("Incompatible Version Detected - File version: " + str(round(version, 1)))
        return {'CANCELLED'}

    offset += 4

    return offset, magic

# Read Bones
def read_bones(buffer, offset):
    # Read Bone Count
    boneCount = unpack_from("i", buffer, offset)[0]
    offset += 4

    # Bones Array
    bones = [  ]

    # Read Bone Names
    for i in range(boneCount):
        bone = readString(buffer, offset)
        bones.append(bone[0])
        offset = bone[1]
    
    return offset, bones

# Read Mesh
def read_mesh(buffer, offset):
    # Imports
    from . import tristrip

    # Get Triangle Count and Vertex Count
    vertexCount = unpack_from("i", buffer, offset)[0]
    triangleCount = unpack_from("i", buffer, offset + 4)[0]
    offset += 8
    
    # Create Vertex Array
    vertices = [  ] * vertexCount

    # Bone Links
    boneLinks = [  ]
    for i in range(8):
        boneLinks.append(unpack_from("b", buffer, offset)[0])
        offset += 1

    # Mesh Attributes
    attributes = [  ]

    # Mesh Attributes Header
    meshAttributesHeader = readString(buffer, offset) # MeshAttributes
    offset = meshAttributesHeader[1]

    # Mesh Attributes
    meshAttributesCount = unpack_from("i", buffer, offset)[0]
    offset += 4

    for i in range(meshAttributesCount):
        stuff = readString(buffer, offset)
        attributes.append(stuff[0])
        offset = stuff[1]

    # Vertices
    offset = readString(buffer, offset)[1]
    
    # Position
    if "Position" in attributes:
        offset = readString(buffer, offset)[1]
        for i in range(vertexCount):
            vertices.append(Vertex())
            vertices[i].position = [ 0, 0, 0 ]
            vertices[i].position[0] = -unpack_from("f", buffer, offset)[0]
            vertices[i].position[1] = unpack_from("f", buffer, offset + 4)[0]
            vertices[i].position[2] = unpack_from("f", buffer, offset + 8)[0]
            vertices[i].index = i
            offset += 12
        
    print(attributes)
    
    # Normal (skip because we dont need it, we recalculate the normals)
    if "Normal" in attributes:
        offset = readString(buffer, offset)[1]
        for i in range(vertexCount):
            offset += 4
    
    # Tangent (skip because we dont need it)
    if "Tangent" in attributes:
        offset = readString(buffer, offset)[1]
        for i in range(vertexCount):
            offset += 4
    
    # Bitangent (skip because we dont need it)
    if "Bitangent" in attributes:
        offset = readString(buffer, offset)[1]
        for i in range(vertexCount):
            offset += 4
    
    # ColourSet1 (skip because we dont need it)
    if "ColourSet1" in attributes:
        offset = readString(buffer, offset)[1]
        for i in range(vertexCount):
            offset += 4
    
    # ColourSet2 (skip because we dont need it)
    if "ColourSet2" in attributes:
        offset = readString(buffer, offset)[1]
        for i in range(vertexCount):
            offset += 4
    
    # UVSet1
    if "UVSet1" in attributes:
        offset = readString(buffer, offset)[1]
        for i in range(vertexCount):
            vertices[i].uvSet1 = [ 0, 0 ]
            vertices[i].uvSet1[0] = unpack_from("f", buffer, offset + 0)[0]
            vertices[i].uvSet1[1] = unpack_from("f", buffer, offset + 4)[0]
            offset += 8
    
    # UVSet2
    if "UVSet2" in attributes:
        offset = readString(buffer, offset)[1]
        for i in range(vertexCount):
            vertices[i].uvSet2 = [ 0, 0 ]
            vertices[i].uvSet2[0] = unpack_from("f", buffer, offset + 0)[0]
            vertices[i].uvSet2[1] = unpack_from("f", buffer, offset + 4)[0]
            offset += 8
    
    # Tangents
    if "Tangents" in attributes:
        offset = readString(buffer, offset)[1]
        for i in range(vertexCount):
            offset += 4
    
    # Blend Indices
    if "BlendIndices" in attributes:
        offset = readString(buffer, offset)[1]
        for i in range(vertexCount):
            vertices[i].blendIndices = [ 0, 0, 0, 0 ]
            vertices[i].blendIndices[0] = unpack_from("b", buffer, offset + 0)[0]
            vertices[i].blendIndices[1] = unpack_from("b", buffer, offset + 1)[0]
            vertices[i].blendIndices[2] = unpack_from("b", buffer, offset + 2)[0]
            vertices[i].blendIndices[3] = 0
            offset += 4
    
    # Blend Weights
    if "BlendWeights" in attributes:
        offset = readString(buffer, offset)[1]
        for i in range(vertexCount):
            vertices[i].blendWeights = [ 0, 0, 0, 0 ]
            vertices[i].blendWeights[0] = unpack_from("B", buffer, offset + 0)[0] / 255
            vertices[i].blendWeights[1] = unpack_from("B", buffer, offset + 1)[0] / 255
            vertices[i].blendWeights[2] = unpack_from("B", buffer, offset + 2)[0] / 255
            vertices[i].blendWeights[3] = unpack_from("B", buffer, offset + 3)[0] / 255
            offset += 4
    
    # Triangles
    offset = readString(buffer, offset)[1]
    
    # Triangles Array
    triangles = []
    for i in range(triangleCount+2):
        triangles.append(unpack_from("H", buffer, offset)[0])
        offset += 2

    print(offset)

    # Dynamic Buffers
    offset = readString(buffer, offset)[1]

    # Dynamic Buffer Count
    dynamicBufferCount = unpack_from("i", buffer, offset)[0]
    offset += 4

    # Dynamic Buffers Loop
    dynamicBuffers = [  ]
    for i in range(dynamicBufferCount):
        dynamicBuffer = [  ]
        for v in range(vertexCount):
            vertex = [ 0, 0, 0 ]
            vertex[0] = -unpack_from("f", buffer, offset)[0]
            vertex[1] = unpack_from("f", buffer, offset + 4)[0]
            vertex[2] = unpack_from("f", buffer, offset + 8)[0]
            offset += 12
            dynamicBuffer.append(vertex)
        dynamicBuffers.append(dynamicBuffer)
    
    # Triangulate Triangles
    strips = tristrip.triangulate([triangles])

    # Return Data
    return vertices, strips, dynamicBuffers, boneLinks, offset

def read_and_create_mesh(data, offset, bones, name = "Mesh", material = None, bone = None, boneIndex = None):
    # Imports
    import time
    import bpy
    import math
    from . import tristrip
    import bmesh

    # Mesh Header
    meshHeader = readString(data, offset) # Mesh
    offset = meshHeader[1]

    # Read Mesh
    vertices, triangles, shapeKeys, boneLinks, offset = read_mesh(data, offset)

    # Deselect All Meshes
    for ob in bpy.context.selected_objects:
        ob.select_set(False)

    # Create Mesh
    mesh = bpy.data.meshes.new(name)

    # Create New Object
    obj = bpy.data.objects.new(name, mesh)
    bpy.context.collection.objects.link(obj)
    bpy.context.view_layer.objects.active = obj
    obj.select_set(True)

    # Create new BMesh
    mesh = bmesh.new()
    mesh.from_mesh(obj.data)

    # Evaluate Vertex Attributes
    attributes = evaluate_vertex_attributes(vertices)

    # Add Vertices To Mesh
    bm_verts = []
    for i, vertex in enumerate(vertices):
        v = mesh.verts.new((vertex.position[0], vertex.position[1], vertex.position[2]))
        #v.index = i  # Not guaranteed to be kept, but we can tag manually
        #v_tag = bm.verts.layers.int.new("orig_index") if i == 0 else bm.verts.layers.int.get("orig_index")
        #v[v_tag] = i
        #bm_verts.append(v)
    
    # Ensure lookup table
    mesh.verts.ensure_lookup_table()
    mesh.faces.ensure_lookup_table()

    # Add Triangles
    for triangle in triangles:
        mesh.faces.ensure_lookup_table()
        mesh.faces.new([mesh.verts[list (triangle)[2]], mesh.verts[list (triangle)[1]], mesh.verts[list (triangle)[0]]])
        mesh.faces.ensure_lookup_table()
    
    # Update Normals
    mesh.normal_update()
    mesh.verts.index_update()
    mesh.verts.ensure_lookup_table()
    mesh.faces.ensure_lookup_table()

    # Create UVSet1
    if "UVSet1" in attributes:
        uvSet1 = mesh.loops.layers.uv.new("uvSet1")
        for face in mesh.faces:
            for loop in face.loops:
                loop[uvSet1].uv = [vertices[loop.vert.index].uvSet1[0], -vertices[loop.vert.index].uvSet1[1]]

    # Create UVSet2
    if "UVSet2" in attributes:
        uvSet2 = mesh.loops.layers.uv.new("uvSet2")
        for face in mesh.faces:
            for loop in face.loops:
                loop[uvSet2].uv = [vertices[loop.vert.index].uvSet2[0], -vertices[loop.vert.index].uvSet2[1]]
    
    # Apply Mesh
    mesh.to_mesh(obj.data)
    
    # Create Vertex Groups
    vertex_groups = []
    if "BlendIndices" in attributes:
        for i, boneLink in enumerate(boneLinks):
            if boneLink == -1:
                continue
            elif boneLink >= len(bones):
                continue
            vertex_groups.append(bpy.context.active_object.vertex_groups.new(name=bones[boneLink]))
        
        # Apply Skinning Data
        if len(vertex_groups) > 0:
            for vert in obj.data.vertices:
                vertex = []
                vertex.append(vert.index)
                vertex_groups[vertices[vert.index].blendIndices[0]].add(vertex, vertices[vert.index].blendWeights[0], 'ADD')
                vertex_groups[vertices[vert.index].blendIndices[1]].add(vertex, vertices[vert.index].blendWeights[1], 'ADD')
                vertex_groups[vertices[vert.index].blendIndices[2]].add(vertex, vertices[vert.index].blendWeights[2], 'ADD')

    # Check if dynamic buffers exist
    if len(shapeKeys) > 0:
        # Create Basis Shape Key
        sk_basis = obj.shape_key_add(name="Basis")
        sk_basis.interpolation = 'KEY_LINEAR'
        obj.data.shape_keys.use_relative = True

        # Dynamic Buffers
        for i, shapeKey in enumerate(shapeKeys):
            # Create new shape key
            sk = obj.shape_key_add(name="Pose " + str(i))
            sk.interpolation = 'KEY_LINEAR'
            sk.slider_min = 0
            sk.slider_max = 1
            sk.value = 0
            sk.relative_key = sk_basis

            # Position
            for v, vert in enumerate(mesh.verts):
                #index = find_in_vertices(vertices, [sk.data[v].co.x, sk.data[v].co.y, sk.data[v].co.z])
                #print(str(sk.data[v].co.x) + " " + str(vertices[index][0]))
                #print(str(v) + " " + str(index))
                sk.data[v].co.x += shapeKey[vert.index][0]
                sk.data[v].co.y += shapeKey[vert.index][1]
                sk.data[v].co.z += shapeKey[vert.index][2]

    # Smooth Shading I Think
    mesh = obj.data
    for f in mesh.polygons:
        f.use_smooth = True

    # Auto Parent To Armature
    object_list = bpy.context.scene.objects
    armature_list = [o for o in object_list if o.type=='ARMATURE']

    # Set Material
    if material != None:
        bpy.context.active_object.data.materials.append(bpy.data.materials.get("Material" + str(material)))

    # Check if there is an armature
    if len(armature_list) > 0 and len(vertex_groups) > 0:
        obj.parent = armature_list[0]
        obj.parent_type = 'ARMATURE'
    else:
        # Rotate 90 degrees
        if (bone != None):
            print("Bone is:" + str(bone))
            obj.location = bone.to_translation()
            obj.location[0] = -obj.location[0]
            obj.location[2] = -obj.location[2]
            obj.rotation_euler = bone.to_euler()
            bpy.ops.object.transform_apply(location=False, rotation=True, scale=True)
            obj.scale = bone.to_scale()
            obj.scale[0] = -obj.scale[0]
            bpy.ops.object.transform_apply(location=False, rotation=True, scale=True)
            
            # Parent Time
            if len(armature_list) > 0:
                obj.parent = armature_list[0]
                obj.parent_type = 'BONE'
                obj.parent_bone = bones[boneIndex]
                # Step 4: Apply transforms to reset the object's position relative to the world
                obj.matrix_parent_inverse = armature_list[0].matrix_world.inverted()  # Inverse of armature's world matrix
                obj.location = obj.matrix_world.translation  # Store the world position
                obj.rotation_euler = obj.rotation_euler.copy()  # Store the world rotation
                obj.scale = obj.scale.copy()  # Store the world scale
                
                # Now, set the object’s parent matrix to reset its local transform
                obj.matrix_world = obj.matrix_world  # Apply the matrix transformations
        else:
            bpy.context.active_object.rotation_euler[0] = math.radians(90)

    
    return offset

def bactaTankMesh(filepath):
    # Imports
    import time
    import bpy
    import math
    from . import tristrip
    import bmesh

    bpy.context.scene.cursor.location = (0.0, 0.0, 0.0)

    t = time.time()
    meshName = bpy.path.display_name_from_filepath(filepath)

    # Load Data
    data = bytearray()
    with open(filepath, 'rb') as file:
        data = file.read()

    # Offset
    offset = 0

    # Read Header
    offset, magic = read_header(data, offset)

    # Read Bones
    bonesHeader = readString(data, offset) # Bones
    offset = bonesHeader[1]
    
    # Read Bones
    offset, bones = read_bones(data, offset)

    # Read and Create Mesh
    read_and_create_mesh(data, offset, bones, name=meshName)

    print("\nSuccessfully imported %r in %.3f sec" % (filepath, time.time() - t))

    return {'FINISHED'}

def importMesh(operator, context, filepath=""):
    return bactaTankMesh(filepath)

def importModel(operator, context, filepath=""):
    # Imports
    import time
    import bpy
    import math
    import mathutils
    from . import tristrip
    import bmesh
    import os
    from pathlib import Path

    bpy.context.scene.cursor.location = (0.0, 0.0, 0.0)

    t = time.time()

    # Load Data
    data = bytearray()
    with open(filepath, 'rb') as file:
        data = file.read()

    # Offset
    offset = 0

    # Read Header
    offset, magic = read_header(data, offset)

    # Read Armature
    armatureHeader = readString(data, offset) # Armature
    offset = armatureHeader[1]

    # Bones Header
    offset = readString(data, offset)[1] # Bones

    # Bone Count
    boneCount = unpack_from("i", data, offset)[0]
    offset += 4
    print(boneCount)

    # Create Armature
    armature = bpy.ops.object.armature_add()

    # Go into Edit Mode
    bpy.ops.object.mode_set(mode='EDIT', toggle=False)
    armatureObject = bpy.context.active_object
    bones = armatureObject.data.edit_bones
    boneNames = [  ]
    boneMatrices = [  ]
    
    for bone in bones:
        armatureObject.data.edit_bones.remove(bone)

    # Bone Count
    for i in range(boneCount):
        # Bone Name
        boneName = readString(data, offset)
        offset = boneName[1]
        matrixArray = []

        # Parent Index
        boneParentIndex = unpack_from("i", data, offset)[0]
        offset += 4

        # Read Matrix
        for m in range(16):
            matrixArray.append(unpack_from("f", data, offset)[0])
            offset += 4

        # Bone Position
        boneX = -matrixArray[12]
        boneY = matrixArray[13]
        boneZ = matrixArray[14]

        # Create Bone
        boneNames.append(boneName[0])
        bone = bones.new(boneName[0])
        bone.head = (boneX, boneY, boneZ)
        bone.tail = (boneX, boneY + 0.02, boneZ)

        # Convert Matrix Stream to Row Sequence
        matrixRows = [matrixArray[i:i+4] for i in range(0, 16, 4)]

        # Create Blender Matrix
        matrix = mathutils.Matrix(matrixRows)
        matrix.transpose()
        boneMatrices.append(matrix)

        # Set Parent
        if boneParentIndex != -1:
            bone.parent = bones[boneParentIndex]
    
    # Rotate 90 degrees
    bpy.context.active_object.rotation_euler[0] = math.radians(90)
    
    # Go into Object mode
    bpy.ops.object.mode_set(mode='OBJECT', toggle=False)

    # Read Materials
    materialHeader = readString(data, offset) # Materials
    offset = materialHeader[1]

    # Material Count
    materialCount = unpack_from("i", data, offset)[0]
    offset += 4

    # Loop Materials And Make Them
    for i in range(materialCount):
        # Read Name
        materialName = readString(data, offset) # Materials
        offset = materialName[1]

        # New Material
        newMaterial = bpy.data.materials.new(materialName[0])
        newMaterial.use_nodes = True

        # Read Material Colour
        colourR = unpack_from("f", data, offset)[0]
        colourG = unpack_from("f", data, offset + 4)[0]
        colourB = unpack_from("f", data, offset + 8)[0]
        colourA = unpack_from("f", data, offset + 12)[0]

        # Skip over this for now
        offset += 0x44
        print(offset)

        # Texture Name
        textureName = readString(data, offset) # textureName
        offset = textureName[1]

        # Normal Name
        normalName = readString(data, offset) # normalName
        offset = normalName[1]

        # Load Image
        image_path = os.path.dirname(filepath) + "\\" + textureName[0]
        if textureName[0] != "None" and Path(image_path).is_file():
            image = bpy.data.images.load(image_path)

            # Get Nodes
            nodes = newMaterial.node_tree.nodes

            image_texture_node = nodes.new(type='ShaderNodeTexImage')
            image_texture_node.image = image

            principled_bsdf_node = nodes.get("Principled BSDF")

            newMaterial.node_tree.links.new(image_texture_node.outputs["Color"], principled_bsdf_node.inputs["Base Color"])

            newMaterial.node_tree.links.new(image_texture_node.outputs["Alpha"], principled_bsdf_node.inputs["Alpha"])

            newMaterial.blend_method = 'HASHED'
            #newMaterial.shadow_method = 'NONE'
            newMaterial.show_transparent_back = False
        else:
            # Get the Principled BSDF node
            nodes = newMaterial.node_tree.nodes
            bsdf = nodes.get("Principled BSDF")

            # If the node doesn't exist, add it
            if bsdf is None:
                bsdf = nodes.new(type="ShaderNodeBsdfPrincipled")

            # Set the base color (RGBA)
            bsdf.inputs["Base Color"].default_value = (colourR, colourG, colourB, colourA)  # Red-ish
    
    # Read Meshes
    meshesHeader = readString(data, offset) # Meshes
    offset = meshesHeader[1]

    # Mesh Count
    meshCount = unpack_from("i", data, offset)[0]
    offset += 4

    # Loop Meshes
    for i in range(meshCount):
        # Read Name
        meshName = readString(data, offset) # meshName
        offset = meshName[1]

        # Material
        meshMaterial = unpack_from("i", data, offset)[0]
        offset += 4

        # Bone
        meshBone = unpack_from("i", data, offset)[0]
        offset += 4

        # Bone Matrix
        boneMatrix = None
        if meshBone != -1:
            # Flip Z scale (negate Z scale)
            flip_z_scale_matrix = mathutils.Matrix((
                ( 1,  0,  0,  0),  # X scale unchanged
                ( 0,  1,  0,  0),  # Y scale unchanged
                ( 0,  0, -1,  0),  # Flip Z scale (negate)
                ( 0,  0,  0,  1)   # Homogeneous coordinate
            ))

            # Rotation matrix for -90 degrees around the X-axis
            rotate_x_matrix = mathutils.Matrix((
                ( 1,  0,  0,  0),
                ( 0,  0,  1,  0),
                ( 0, -1,  0,  0),
                ( 0,  0,  0,  1)
            ))
            boneMatrix = rotate_x_matrix @ flip_z_scale_matrix @ boneMatrices[meshBone]
        
        # Read and Create Mesh
        offset = read_and_create_mesh(data, offset, boneNames, name=meshName[0], material=meshMaterial, bone=boneMatrix, boneIndex=meshBone)

    print("\nSuccessfully imported %r in %.3f sec" % (filepath, time.time() - t))

    return {'FINISHED'}

def bactaTankArmature(filepath):
    # Imports
    import time
    import bpy
    import math
    from . import tristrip

    bpy.context.scene.cursor.location = (0.0, 0.0, 0.0)

    t = time.time()
    ttm_name = bpy.path.display_name_from_filepath(filepath)

    # Load Data
    data = bytearray()
    with open(filepath, 'rb') as file:
        data = file.read()

    # Offset
    offset = 0

    # BactaTankArmature and PCGHG
    offset = readString(data, offset)[1] # BactaTankArmature
    offset = readString(data, offset)[1] # PCGHG

    # Check version is 0.4
    version = unpack_from("f", data, offset)[0]
    offset += 4

    # Bones Header
    offset = readString(data, offset)[1] # Bones

    # Bone Count
    boneCount = unpack_from("i", data, offset)[0]
    offset += 4
    print(boneCount)

    # Create Armature
    armature = bpy.ops.object.armature_add()

    # Go into Edit Mode
    bpy.ops.object.mode_set(mode='EDIT', toggle=False)
    armatureObject = bpy.context.active_object
    bones = armatureObject.data.edit_bones
    
    for bone in bones:
        armatureObject.data.edit_bones.remove(bone)

    # Bone Count
    for i in range(boneCount):
        # Bone Name
        boneName = readString(data, offset)
        offset = boneName[1]

        # Parent Index
        boneParentIndex = unpack_from("i", data, offset)[0]
        offset += 4

        # Bone Position
        boneX = -unpack_from("f", data, offset + 48)[0]
        boneY = unpack_from("f", data, offset + 52)[0]
        boneZ = unpack_from("f", data, offset + 56)[0]
        offset += 64

        # Create Bone
        bone = bones.new(boneName[0])
        bone.head = (boneX, boneY, boneZ)
        bone.tail = (boneX, boneY + 0.02, boneZ)

        # Set Parent
        if boneParentIndex != -1:
            bone.parent = bones[boneParentIndex]
    
    # Rotate 90 degrees
    bpy.context.active_object.rotation_euler[0] = math.radians(90)
    
    # Go into Object mode
    bpy.ops.object.mode_set(mode='OBJECT', toggle=False)

def importArmature(operator, context, filepath=""):
    return bactaTankArmature(filepath)