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

# <pep8-80 compliant>

bl_info = {
    "name": "BactaTank Classic v0.3 Format",
    "author": "Alub",
    "version": (3, 2, 0),
    "blender": (4, 0, 0),
    "location": "File > Import/Export",
    "description": "Import-Export TtGames mesh data for use in BactaTank Classic v0.3",
    "doc_url": "",
    "support": 'COMMUNITY',
    "category": "Import-Export",
}

if "bpy" in locals():
    import importlib
    if "export_bactatank" in locals():
        importlib.reload(export_bactatank)
    if "import_bactatank" in locals():
        importlib.reload(import_bactatank)


import bpy
from bpy.props import (
    CollectionProperty,
    StringProperty,
    BoolProperty,
    FloatProperty,
    EnumProperty,
)
from bpy_extras.io_utils import (
    ImportHelper,
    ExportHelper,
    axis_conversion,
    orientation_helper,
)

@orientation_helper(axis_forward='-Z', axis_up='Y')
class ImportTTM(bpy.types.Operator, ImportHelper):
    bl_idname = "import_mesh.bmesh"
    bl_label = "Import BactaTank Classic v0.3 Mesh"
    bl_description = "Import mesh exported from BactaTank Classic v0.3"
    bl_options = {'UNDO'}

    files: CollectionProperty(
        name="File Path",
        description="File path used for importing the BactaTank file",
        type=bpy.types.OperatorFileListElement,
    )

    # Hide opertator properties, rest of this is managed in C. See WM_operator_properties_filesel().
    hide_props_region: BoolProperty(
        name="Hide Operator Properties",
        description="Collapse the region displaying the operator settings",
        default=True,
    )

    directory: StringProperty()

    filename_ext = ".bmesh"
    filter_glob: StringProperty(default="*.bmesh", options={'HIDDEN'})

    def execute(self, context):
        import os
        from . import import_bactatank

        context.window.cursor_set('WAIT')

        paths = [
            os.path.join(self.directory, name.name)
            for name in self.files
        ]

        if not paths:
            paths.append(self.filepath)

        for path in paths:
            import_bactatank.importMesh(self, context, path)

        context.window.cursor_set('DEFAULT')

        return {'FINISHED'}


@orientation_helper(axis_forward='-Z', axis_up='Y')
class ExportTTM(bpy.types.Operator, ExportHelper):
    bl_idname = "export_mesh.bmesh"
    bl_label = "Export BactaTank Classic v0.3 Mesh"
    bl_description = "Export mesh for use in BactaTank Classic v0.3"

    filename_ext = ".bmesh"
    filter_glob: StringProperty(default="*.bmesh", options={'HIDDEN'})

    export_skinning: BoolProperty(
        name="Export Skinning",
        description="Export the skinning information",
        default=False,
    )
    export_shape_keys: BoolProperty(
        name="Export Shape Keys",
        description="Export the shape key information for face and hand poses",
        default=False,
    )
    use_selection: BoolProperty(
        name="Selection Only",
        description="Export selected objects only",
        default=False,
    )
    use_mesh_modifiers: BoolProperty(
        name="Apply Modifiers",
        description="Apply Modifiers to the exported mesh",
        default=True,
    )
    export_version: EnumProperty(
        name="Export Version",
        description="What version of TtGames Mesh to export to.",
        items=[
            #("hgo", "HGO/NUP", "Export to HGO/NUP Version", 0),
            ("pcghg", "PCGHG", "Export to PCGHG Version", 0),
            #("nxglij2", "NXG-LIJ2", "Export to NXG Version", 1),
            #("dx11", "DX11", "Export to DX11 Version", 3),
        ],
        default="pcghg",
    )

    def execute(self, context):
        from mathutils import Matrix
        from . import export_bactatank

        context.window.cursor_set('WAIT')

        keywords = self.as_keywords(
            ignore=(
                "axis_forward",
                "axis_up",
                "global_scale",
                "check_existing",
                "filter_glob",
            )
        )
        global_matrix = axis_conversion(
            to_forward=self.axis_forward,
            to_up=self.axis_up,
        ).to_4x4() @ Matrix.Scale(1, 4)
        keywords["global_matrix"] = global_matrix

        export_bactatank.exportMesh(context, **keywords)

        context.window.cursor_set('DEFAULT')

        return {'FINISHED'}

class ImportArmature(bpy.types.Operator, ImportHelper):
    bl_idname = "import_armature.barm"
    bl_label = "Import BactaTank Classic Armature"
    bl_description = "Import Armature Exported From BactaTank Classic"
    bl_options = {'UNDO'}

    files: CollectionProperty(
        name="File Path",
        description="File path used for importing the BactaTank Classic Armature",
        type=bpy.types.OperatorFileListElement,
    )

    # Hide opertator properties, rest of this is managed in C. See WM_operator_properties_filesel().
    hide_props_region: BoolProperty(
        name="Hide Operator Properties",
        description="Collapse the region displaying the operator settings",
        default=True,
    )

    directory: StringProperty()

    filename_ext = ".barm"
    filter_glob: StringProperty(default="*.barm", options={'HIDDEN'})
    
    def execute(self, context):
        import os
        from . import import_bactatank

        context.window.cursor_set('WAIT')

        paths = [
            os.path.join(self.directory, name.name)
            for name in self.files
        ]

        if not paths:
            paths.append(self.filepath)

        for path in paths:
            import_bactatank.importArmature(self, context, path)

        context.window.cursor_set('DEFAULT')

        return {'FINISHED'}

class ImportModel(bpy.types.Operator, ImportHelper):
    bl_idname = "import_model.bmodel"
    bl_label = "Import BactaTank Classic Model"
    bl_description = "Import Model Exported From BactaTank Classic"
    bl_options = {'UNDO'}

    files: CollectionProperty(
        name="File Path",
        description="File path used for importing the BactaTank Classic Model",
        type=bpy.types.OperatorFileListElement,
    )

    # Hide opertator properties, rest of this is managed in C. See WM_operator_properties_filesel().
    hide_props_region: BoolProperty(
        name="Hide Operator Properties",
        description="Collapse the region displaying the operator settings",
        default=True,
    )

    directory: StringProperty()

    filename_ext = ".bmodel"
    filter_glob: StringProperty(default="*.bmodel", options={'HIDDEN'})
    
    def execute(self, context):
        import os
        from . import import_bactatank

        context.window.cursor_set('WAIT')

        paths = [
            os.path.join(self.directory, name.name)
            for name in self.files
        ]

        if not paths:
            paths.append(self.filepath)

        for path in paths:
            import_bactatank.importModel(self, context, path)

        context.window.cursor_set('DEFAULT')

        return {'FINISHED'}

class ImportSubmenu(bpy.types.Menu):
    bl_idname = "submenu.bactatank"
    bl_label = "BactaTank Classic v0.3"

    def draw(self, context):
        layout = self.layout

        layout.operator(ImportTTM.bl_idname, text="Mesh (*.bmesh)")
        layout.operator(ImportArmature.bl_idname, text="Armature (*.barm)")
        layout.operator(ImportModel.bl_idname, text="Model (*.bmodel)")

def menu_func_import(self, context):
    self.layout.menu(ImportSubmenu.bl_idname, text="BactaTank Classic v0.3")
    #self.layout.operator(ImportTTM.bl_idname, text="BactaTank Classic v0.3 Mesh (.btank)")


def menu_func_export(self, context):
    self.layout.operator(ExportTTM.bl_idname, text="BactaTank Classic v0.3 Mesh (.bmesh)")


classes = (
    ImportTTM,
    ExportTTM,
    ImportArmature,
    ImportModel,
    ImportSubmenu,
)


def register():
    for cls in classes:
        bpy.utils.register_class(cls)

    bpy.types.TOPBAR_MT_file_import.append(menu_func_import)
    bpy.types.TOPBAR_MT_file_export.append(menu_func_export)


def unregister():
    for cls in classes:
        bpy.utils.unregister_class(cls)

    bpy.types.TOPBAR_MT_file_import.remove(menu_func_import)
    bpy.types.TOPBAR_MT_file_export.remove(menu_func_export)


if __name__ == "__main__":
    register()
