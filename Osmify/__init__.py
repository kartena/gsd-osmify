import os.path
import glob
import Osmify.util as util

class GsdMap:
    def __init__(self, map_dir):
        self.map_dir = map_dir

    def prototype_files(self):
        # All Shape files in the all direct subdir we can find.
        result = {}
        for root, dirs, files, level in util.walk2(self.map_dir):
            if level == 1:
                for f in [(os.path.split(f)[1].split('_')[0], os.path.join(root, f)) for f in files if os.path.splitext(f)[1] == '.shp']:
                              result[f[0]] = f[1]

        return result.values()

    def data_files(self):
        result = []
        for root, dirs, files, level in util.walk2(self.map_dir):
            if level == 1:
                # All Shape files except tl_*.shp and tx_*.shp
                result += [os.path.join(root, f) for f in files if os.path.splitext(f)[1] == '.shp' \
                    and not (os.path.split(f)[1].startswith('tl_') or os.path.split(f)[1].startswith('tx_'))]
            elif level > 1:
                # Should only be Shape files in "gis_text"
                result += [os.path.join(root, f) for f in files if os.path.splitext(f)[1] == '.shp']

        return result

    def index_columns(self):
        return ['kkod', 'kategori']

class Oversiktskartan(GsdMap):
    def __init__(self, base_dir):
        GsdMap.__init__(self, os.path.join(base_dir, 'oversikt'))

class Terrangkartan(GsdMap):
    def __init__(self, base_dir):
        GsdMap.__init__(self, os.path.join(base_dir, 'terrang'))

class Vagkartan(GsdMap):
    def __init__(self, base_dir):
        GsdMap.__init__(self, os.path.join(base_dir, 'vagk'))

class Tatortskartan(GsdMap):
    def __init__(self, base_dir):
        GsdMap.__init__(self, os.path.join(base_dir, 'tatort'))

    def index_columns(self):
        return ['kod', 'objekt']
