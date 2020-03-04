{ pkgs, ... }:

''
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 00 action set button 1 # Left Click
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 01 action set button 2 # Right Click
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 02 action set button 3 # Middle Click
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 03 action set button 4 # MWheel Left
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 04 action set button 5 # MWheel Right
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 05 action set button 5 # Ring Click
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 06 action set macro +KEY_LEFTSHIFT KEY_RESERVED -KEY_LEFTSHIFT #G07
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 07 action set macro +KEY_LEFTMETA KEY_RESERVED -KEY_LEFTMETA #G08
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 08 action set macro KEY_1 #G09
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 09 action set macro KEY_2 #G10
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 10 action set macro KEY_3 #G11
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 11 action set macro KEY_4 #G12
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 12 action set macro KEY_5 #G13
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 13 action set macro KEY_6 #G14
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 14 action set macro KEY_7 #G15
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 15 action set macro KEY_8 #G16
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 16 action set macro KEY_9 #G17
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 17 action set macro KEY_0 #G18
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 18 action set macro KEY_MINUS #G19
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 button 19 action set macro KEY_EQUAL #G20
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 dpi set 400
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 led 0 set color 00ff00
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 led 0 set mode on
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile 0 rate set 1000
  ${pkgs.libratbag}/bin/ratbagctl 'Logitech Gaming Mouse G600' profile active set 0
  echo G600 Configured...
''
