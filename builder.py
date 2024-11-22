import os
from setuptools.command.build_ext import build_ext


class ZigBuilder(build_ext):
    def build_extension(self, ext):
        assert len(ext.sources) == 1

        if not os.path.exists(self.build_lib):
            os.makedirs(self.build_lib)

        # mode = "Debug" if self.debug else "ReleaseFast"
        mode = "ReleaseFast"

        self.spawn(
            [
                "zig",# your zig compiler binary path
                "build-lib",
                "-O",
                mode,
                "-lc",
                f"-femit-bin={self.get_ext_fullpath(ext.name)}",
                "-dynamic",
                *[f"-I{d}" for d in self.include_dirs],
                ext.sources[0],
            ]
        )
