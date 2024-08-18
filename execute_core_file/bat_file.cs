using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace execute_core_file
{
    class bat_file
    {
        public static void executeBatchFile(string file_name)
        {
            try
            {
                Process proc = null;
                string targetDir = Application.StartupPath;//this is where mybatch.bat lies
                proc = new Process();
                proc.StartInfo.WorkingDirectory = targetDir;
                proc.StartInfo.FileName = file_name;
                proc.StartInfo.Arguments = string.Format("10");//this is argument
                proc.StartInfo.CreateNoWindow = false;
                proc.Start();
                proc.WaitForExit();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception Occurred :{0},{1}", ex.Message, ex.StackTrace.ToString());
            }
        }

        public static void executeCMD(string to_execute)
        {
            try
            {
                Process cmd = new System.Diagnostics.Process();

                cmd.StartInfo.FileName = @"C:\windows\system32\cmd.exe";
                cmd.StartInfo.UseShellExecute = false;
                cmd.StartInfo.RedirectStandardInput = true;
                cmd.StartInfo.RedirectStandardOutput = true;
                cmd.StartInfo.CreateNoWindow = true;

                cmd.Start();
              //  string to_execute = "kitty.exe -ssh root@10.108.112.120 -pw q -cmd \"cd /home/kos/control; ls -lat\"";
                cmd.StandardInput.WriteLine(to_execute);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception Occurred :{0},{1}", ex.Message, ex.StackTrace.ToString());
            }
        }


        public static void WriteLogFile(string ip_numeber , string DevCore, string Path_core ,string core_out_put)
        {
            core_out_put = core_out_put + ".txt";
            try
            {
                String toWrite ="";
                if (Path_core.Contains(".gz"))
                {
                    toWrite = "plink.exe -pw admin -ssh root@" + ip_numeber + " gunzip " + Path_core + "\n";
                    Path_core = Path_core.Substring(0, Path_core.Length - 3);
                }
                toWrite = toWrite + "plink.exe -pw admin -ssh root@" + ip_numeber + " gdb " + "/usr/sbin/" + DevCore + " --core " + Path_core + " --batch --quiet  -ex 'set logging on'  -ex 'info thread' -ex 'where' -ex 'thread apply all bt full' -ex 'quit'  > " + ip_numeber + "\\" + core_out_put + "_FULL\n";
                toWrite = toWrite + "plink.exe -pw admin -ssh root@" + ip_numeber + " gdb " + "/usr/sbin/" + DevCore + " --core " + Path_core + " --batch --quiet -ex 'info thread' -ex 'where' -ex 'thread apply all bt' -ex 'quit'  > " + ip_numeber + "\\" + core_out_put + "\n";
                toWrite = toWrite + "plink.exe -pw admin -ssh root@" + ip_numeber + " /usr/bin/strings " + Path_core + "  >> " + ip_numeber + "\\" + core_out_put + "_strings";
          // home/kos/kashya/archive/bin/release/ before 5.2sp2
                    String FilePathLog = "@" + Application.StartupPath + "\\Log_ssh.bat";

                    using (FileStream file = new FileStream(Application.StartupPath + "\\plink.bat", FileMode.OpenOrCreate, FileAccess.Write))
                    {

                        StreamWriter streamWriter = new StreamWriter(file);

                        streamWriter.WriteLine(toWrite);

                        streamWriter.Close();
                    }






                }

            

          catch
      {
          MessageBox.Show("error on create file");

         }

        }


    }
}
