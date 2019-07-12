project('gamemode-explorer', 'vala', 'c')

glib = dependency('glib-2.0')
gio  = dependency('gio-2.0')
gtk  = dependency('gtk+-3.0')
gee  = dependency('gee-0.8')

src = files(
  ['com-feralinteractive.vala',
   'main.vala',
])

executable(
  'ge-cli',
  dependencies: [glib, gio, gee],
  sources: [src],
  install: true)
