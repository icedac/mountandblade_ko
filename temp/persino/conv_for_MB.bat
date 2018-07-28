set SELECT_ROW=%1
set EXPORT_DIR=export_ko

node conv_for_MB.js "https://docs.google.com/spreadsheets/d/1yvSEsi-rkktvdRdFEZl4DNO_jiC7mO6BAonIPFvd8_E/export?format=csv&gid=1920383473" %SELECT_ROW% %EXPORT_DIR%/dialogs.csv
node conv_for_MB.js "https://docs.google.com/spreadsheets/d/1lpW5nbqtMJfgjpaPDMdxJYr-nJaD-sRE4nilTH0lStU/export?format=csv&gid=861236000" 2 %EXPORT_DIR%/troops.csv
node conv_for_MB.js "https://docs.google.com/spreadsheets/d/1lpW5nbqtMJfgjpaPDMdxJYr-nJaD-sRE4nilTH0lStU/export?format=csv&gid=861236000" 3 %EXPORT_DIR%/leveled.troops.csv


node conv_for_MB.js "https://docs.google.com/spreadsheets/d/1E24MTzG-NuE56rYBLmbgox7H1YoqmJe01CmLB8Q-4dM/export?format=csv&gid=486010222" %SELECT_ROW% %EXPORT_DIR%/skins.csv
node conv_for_MB.js "https://docs.google.com/spreadsheets/d/101Msu7nDbwXUxokiRtpSEa4U3AwuXvoJ_vPHDr3wPwQ/export?format=csv&gid=1016864922" %SELECT_ROW% %EXPORT_DIR%/skills.csv
node conv_for_MB.js "https://docs.google.com/spreadsheets/d/1PcpNFQuDcvf4H4ZBv10zAcvj9SZfQ9eSU7pClcPkDzE/export?format=csv&gid=575300819" %SELECT_ROW% %EXPORT_DIR%/quick_strings.csv
node conv_for_MB.js "https://docs.google.com/spreadsheets/d/1K6UFzAAKuKuVuUJBrhRuwrXs6bXQc2J-T8l1U7CXOV4/export?format=csv&gid=1808548366" %SELECT_ROW% %EXPORT_DIR%/quests.csv
node conv_for_MB.js "https://docs.google.com/spreadsheets/d/1Ahqj2-in37TOlZXeZFzD_zfv1WplwbHPxxKuvCby-7M/export?format=csv&gid=1410392242" %SELECT_ROW% %EXPORT_DIR%/party_templates.csv
node conv_for_MB.js "https://docs.google.com/spreadsheets/d/1xEOZkEjNHa7RGSpagYhEZw_Kj7E9t1VpoaRrQC2faDw/export?format=csv&gid=1916072731" %SELECT_ROW% %EXPORT_DIR%/parties.csv
node conv_for_MB.js "https://docs.google.com/spreadsheets/d/1scchX-DWAfPrpxIXDfRiwaVaONVNSB1A5UOfregFJzA/export?format=csv&gid=707981930" %SELECT_ROW% %EXPORT_DIR%/item_modifiers.csv
node conv_for_MB.js "https://docs.google.com/spreadsheets/d/1WFrTgpAUKCqEHesceMmrCRyR59Vb8_pkOFqMX3V_Aq0/export?format=csv&gid=1534583286" %SELECT_ROW% %EXPORT_DIR%/item_kinds.csv
node conv_for_MB.js "https://docs.google.com/spreadsheets/d/1SXvSiM_EYRh1CUyyYUXOVlHkiwKS0iC4EM6kdMy4Zx0/export?format=csv&gid=1165611906" %SELECT_ROW% %EXPORT_DIR%/info_pages.csv
node conv_for_MB.js "https://docs.google.com/spreadsheets/d/1iTXSK6sGZFxW2M46yU02Oc3kepAmrYBuAbJJrkr3oiQ/export?format=csv&gid=734067127" %SELECT_ROW% %EXPORT_DIR%/game_strings.csv
node conv_for_MB.js "https://docs.google.com/spreadsheets/d/1DxXW6-3zDVk4Nr5LPwS-IZK96Vq2-mmYqzXQNRd-19g/export?format=csv&gid=1676087891" %SELECT_ROW% %EXPORT_DIR%/game_menus.csv
node conv_for_MB.js "https://docs.google.com/spreadsheets/d/1z-zDd9-4rjMoFxLtNXhEwYYd8I7-JNX130YQyYGQ3Uk/export?format=csv&gid=765141959" %SELECT_ROW% %EXPORT_DIR%/factions.csv

node conv_for_MB.js "https://docs.google.com/spreadsheets/d/1N-jkDKDewtEfJkzJCY6cPXHkMU5zXxu2gI-YxVrgZo8/export?format=csv&gid=2123784110" %SELECT_ROW% %EXPORT_DIR%/ui.csv
node conv_for_MB.js "https://docs.google.com/spreadsheets/d/1IK0kfYo68hvb2oL3TZ00WWBPaTergwJ-mEtK4tokmDc/export?format=csv&gid=1333340884" %SELECT_ROW% %EXPORT_DIR%/uimain.csv
node conv_for_MB.js "https://docs.google.com/spreadsheets/d/1hW7aQSMTUhpiKn0WOCllgkXXNGHJkJkceHtyxMhC25w/export?format=csv&gid=463592103" %SELECT_ROW% %EXPORT_DIR%/hints.csv
