from setuptools import setup, find_packages  # Always prefer setuptools over distutils
from codecs import open  # To use a consistent encoding
from os import path

here = path.abspath(path.dirname(__file__))

# Get the long description from the relevant file
with open(path.join(here, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name='tokipona',

    # Versions should comply with PEP440.  For a discussion on single-sourcing
    # the version across setup.py and the project code, see
    # https://packaging.python.org/en/latest/single_source_version.html
    # version='0.1.dev0',
    # according to https://semver.org/
    version='0.01b',

    description='A package for dealing with toki pona: vim syntax highlighting, tokipona wordnets, analysis of the vocabulary, synthesis of texts',
    long_description=long_description,

    # The project's main homepage.
    url='https://github.com/ttm/tokipona',

    # Author details
    author='Renato Fabbri',
    author_email='renato.fabbri@gmail.com',

    # Choose your license
    license='MIT',

    # See https://pypi.python.org/pypi?%3Aaction=list_classifiers
    classifiers=[
        # How mature is this project? Common values are
        #   3 - Alpha
        #   4 - Beta
        #   5 - Production/Stable
        'Development Status :: 4 - Beta',

        # Indicate who your project is intended for
        'Intended Audience :: Science/Research',
        'Intended Audience :: Developers',
        'Intended Audience :: Education',
        'Intended Audience :: Religion',
        'Intended Audience :: Other Audience',
        'License :: OSI Approved :: GNU Lesser General Public License v3 or later (LGPLv3+)',
        'Natural Language :: English',
        'Natural Language :: Toki Pona',
        'Operating System :: Unix',
        'Topic :: Documentation',
        'Topic :: Documentation :: Sphinx',
        'Topic :: Education',
        'Topic :: Education :: Computer Aided Instruction (CAI)',
        'Topic :: Education :: Testing',
        'Topic :: Games/Entertainment',
        'Topic :: Multimedia',
        'Topic :: Multimedia :: Graphics',
        'Topic :: Multimedia :: Graphics :: Editors',
        'Topic :: Multimedia :: Graphics :: Presentation',
        'Topic :: Multimedia :: Graphics :: Viewers',
        'Topic :: Printing',
        'Topic :: Religion',
        'Topic :: Scientific/Engineering',
        'Topic :: Scientific/Engineering :: Artificial Intelligence',
        'Topic :: Text Editors',
        'Topic :: Text Editors :: Documentation',
        'Topic :: Text Editors :: Integrated Development Environments (IDE)',
        'Topic :: Text Editors :: Text Processing',
        'Topic :: Text Editors :: Word Processors',
        'Topic :: Text Processing',
        'Topic :: Text Processing :: Filters',
        'Topic :: Text Processing :: Fonts',
        'Topic :: Text Processing :: General',
        'Topic :: Text Processing :: Linguistic',
        'Topic :: Utilities',


        'Topic :: Scientific/Engineering :: Visualization',
        'Topic :: Scientific/Engineering :: Information Analysis',
        'Topic :: Multimedia :: Sound/Audio :: Sound Synthesis',
        'Topic :: Multimedia :: Sound/Audio :: Speech',
        'Topic :: Artistic Software',
        'Topic :: Other/Nonlisted Topic',

        # Pick your license as you wish (should match "license" above)
        # 'License :: OSI Approved :: Public Domain',
        'License :: OSI Approved :: MIT License',

        # Specify the Python versions you support here. In particular, ensure
        # that you indicate whether you support Python 2, Python 3 or both.
        'Programming Language :: Python :: 3',
    ],

    # What does your project relate to?
    keywords=['toki pona', 'linguistics', 'conlang', 'constructed language',
            'planned language', 'wordnet', 'toki pona wordnet',
            'syntax highlighting', 'vocabulary', 'vocabulary analysis',
            'text synthesis', 'artificial poems', 'color schemes', 'color',
            'Vim', 'vim', 'vi', 'Vi', 'physics', 'synthesis', 'psychophysics',
            'symmetry', 'toolbox', 'art', 'artistic creation',
            'synthesizer', 'PCM', 'audio', 'sound',
            'multimedia', 'speech', 'singing', 'speech synthesis', 'numpy',
            'sonic art'],

    # You can just specify the packages manually here if your project is
    # simple. Or you can use find_packages().
    packages=["tokipona"],
    #packages=find_packages(exclude=['contrib', 'docs', 'tests*']),

    # List run-time dependencies here.  These will be installed by pip when your
    # project is installed. For an analysis of "install_requires" vs pip's
    # requirements files see:
    # https://packaging.python.org/en/latest/requirements.html
    # TODO: test with virtualenv to know the dependencies
    install_requires=['numpy', 'scipy', 'nltk', 'percolation'],

    # List additional groups of dependencies here (e.g. development dependencies).
    # You can install these using the following syntax, for example:
    # $ pip install -e .[dev,test]
    #extras_require = {
    #    'dev': ['check-manifest'],
    #    'test': ['coverage'],
    #},

    # If there are data files included in your packages that need to be
    # installed, specify them here.  If using Python 2.6 or less, then these
    # have to be included in MANIFEST.in as well.
    #package_data={
    #    'sample': ['package_data.dat'],
    #},

    # Although 'package_data' is the preferred approach, in some case you may
    # need to place data files outside of your packages.
    # see http://docs.python.org/3.4/distutils/setupscript.html#installing-additional-files
    # In this case, 'data_file' will be installed into '<sys.prefix>/my_data'
    #data_files=[('my_data', ['data/data_file'])],

    # To provide executable scripts, use entry points in preference to the
    # "scripts" keyword. Entry points provide cross-platform support and allow
    # pip to create the appropriate form of executable for the target platform.
    #entry_points={
    #    'console_scripts': [
    #        'sample=sample:main',
    #    ],
    #},
)

