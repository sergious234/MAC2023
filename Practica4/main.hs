--  $$$$$$$\                                 $$\     $$\                           $$$$$$\  
--  $$  __$$\                                $$ |    \__|                         $$ ___$$\ 
--  $$ |  $$ | $$$$$$\  $$$$$$\   $$$$$$$\ $$$$$$\   $$\  $$$$$$$\ $$$$$$\        \_/   $$ |
--  $$$$$$$  |$$  __$$\ \____$$\ $$  _____|\_$$  _|  $$ |$$  _____|\____$$\         $$$$$ / 
--  $$  ____/ $$ |  \__|$$$$$$$ |$$ /        $$ |    $$ |$$ /      $$$$$$$ |        \___$$\ 
--  $$ |      $$ |     $$  __$$ |$$ |        $$ |$$\ $$ |$$ |     $$  __$$ |      $$\   $$ |
--  $$ |      $$ |     \$$$$$$$ |\$$$$$$$\   \$$$$  |$$ |\$$$$$$$\\$$$$$$$ |      \$$$$$$  |
--  \__|      \__|      \_______| \_______|   \____/ \__| \_______|\_______|       \______/ 


--  ███╗   ███╗ █████╗ ██╗███╗   ██╗    ██████╗ 
--  ████╗ ████║██╔══██╗██║████╗  ██║    ╚════██╗
--  ██╔████╔██║███████║██║██╔██╗ ██║      ▄███╔╝
--  ██║╚██╔╝██║██╔══██║██║██║╚██╗██║      ▀▀══╝ 
--  ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║      ██╗   
--  ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝      ╚═╝   

import Auxiliar 
main :: IO ()
main = do 
  rainbow "Jueguitos de adivinar numeros"
  putStrLn $ fg_azul ++ tab ++ "En un lenguage funcional" ++ fg_end
  putStrLn $ fg_verde ++ tab ++ "Pero programando imperativamente !" ++ fg_end
  menu