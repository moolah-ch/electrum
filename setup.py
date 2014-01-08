#!/usr/bin/python

# python setup.py sdist --format=zip,gztar

from setuptools import setup
import os
import sys
import platform
import imp


version = imp.load_source('version', 'lib/version.py')
util = imp.load_source('version', 'lib/util.py')

if sys.version_info[:3] < (2, 6, 0):
    sys.exit("Error: Shuttle requires Python version >= 2.6.0...")

usr_share = '/usr/share'
if not os.access(usr_share, os.W_OK):
    usr_share = os.getenv("XDG_DATA_HOME", os.path.join(os.getenv("HOME"), ".local", "share"))

data_files = []
if (len(sys.argv) > 1 and (sys.argv[1] == "sdist")) or (platform.system() != 'Windows' and platform.system() != 'Darwin'):
    print "Including all files"
    data_files += [
        (os.path.join(usr_share, 'applications/'), ['shuttle.desktop']),
        (os.path.join(usr_share, 'app-install', 'icons/'), ['icons/shuttle.png'])
    ]
    if not os.path.exists('locale'):
        os.mkdir('locale')
    for lang in os.listdir('locale'):
        if os.path.exists('locale/%s/LC_MESSAGES/shuttle.mo' % lang):
            data_files.append((os.path.join(usr_share, 'locale/%s/LC_MESSAGES' % lang), ['locale/%s/LC_MESSAGES/shuttle.mo' % lang]))

appdata_dir = util.appdata_dir()
if not os.access(appdata_dir, os.W_OK):
    appdata_dir = os.path.join(usr_share, "shuttle")

data_files += [
    (appdata_dir, ["data/README"]),
    (os.path.join(appdata_dir, "cleanlook"), [
        "data/cleanlook/name.cfg",
        "data/cleanlook/style.css"
    ]),
    (os.path.join(appdata_dir, "sahara"), [
        "data/sahara/name.cfg",
        "data/sahara/style.css"
    ]),
    (os.path.join(appdata_dir, "dark"), [
        "data/dark/background.png",
        "data/dark/name.cfg",
        "data/dark/style.css"
    ]),
    (os.path.join(util.appdata_dir(), "certs"), [
        "data/certs/ca-coinbase.crt",
    ])
]


setup(
    name="Shuttle",
    version=version.ELECTRUM_VERSION,
    install_requires=['slowaes', 'ecdsa>=0.9'],
    package_dir={
        'shuttle': 'lib',
        'shuttle_gui': 'gui',
        'shuttle_plugins': 'plugins',
    },
    scripts=['shuttle'],
    data_files=data_files,
    py_modules=[
        'shuttle.account',
        'shuttle.dogecoin',
        'shuttle.blockchain',
        'shuttle.bmp',
        'shuttle.commands',
        'shuttle.i18n',
        'shuttle.interface',
        'shuttle.mnemonic',
        'shuttle.msqr',
        'shuttle.network',
        'shuttle.plugins',
        'shuttle.pyqrnative',
        'shuttle.simple_config',
        'shuttle.socks',
        'shuttle.transaction',
        'shuttle.util',
        'shuttle.verifier',
        'shuttle.version',
        'shuttle.wallet',
        'shuttle.wallet_bitkey',
        'shuttle.wallet_factory',
        'shuttle_gui.gtk',
        'shuttle_gui.qt.__init__',
        'shuttle_gui.qt.amountedit',
        'shuttle_gui.qt.console',
        'shuttle_gui.qt.history_widget',
        'shuttle_gui.qt.icons_rc',
        'shuttle_gui.qt.installwizard',
        'shuttle_gui.qt.lite_window',
        'shuttle_gui.qt.main_window',
        'shuttle_gui.qt.network_dialog',
        'shuttle_gui.qt.password_dialog',
        'shuttle_gui.qt.qrcodewidget',
        'shuttle_gui.qt.receiving_widget',
        'shuttle_gui.qt.seed_dialog',
        'shuttle_gui.qt.transaction_dialog',
        'shuttle_gui.qt.util',
        'shuttle_gui.qt.version_getter',
        'shuttle_gui.stdio',
        'shuttle_gui.text',
        'shuttle_plugins.aliases',
        'shuttle_plugins.coinbase_buyback',
        'shuttle_plugins.exchange_rate',
        'shuttle_plugins.labels',
        'shuttle_plugins.pointofsale',
        'shuttle_plugins.qrscanner',
        'shuttle_plugins.virtualkeyboard',
    ],
    description="Lightweight Dogecoin Wallet",
    author="ecdsa",
    author_email="ecdsa@github",
    license="GNU GPLv3",
    url="http://shuttle.org",
    long_description="""Lightweight Dogecoin Wallet"""
)
