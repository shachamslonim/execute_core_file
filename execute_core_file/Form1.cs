using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace execute_core_file
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            host_list("rpa_list2.txt");

        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            listBox2.Items.Clear();
            // Get the currently selected item in the ListBox. 
            string curItem = listBox1.SelectedItem.ToString();
            const string listCore = "core.txt";
            String pathFile = Application.StartupPath + "\\" + curItem + "\\" + listCore;
            if ( File.Exists(pathFile))
            {
            String TextLine = " ";
            using (StreamReader r = new StreamReader(pathFile))
            {
                while ((TextLine = r.ReadLine()) != null)
                {
                    string sub = TextLine.Substring(23, TextLine.Length - 23);
                    listBox2.Items.Add(sub);

                    //   String pathFile = Application.StartupPath + "\\" + line;
                }

            }
            button2.Visible = false;
            label3.Text = "Step 2 : press on the core that you want to open as BT ";
            }
        }

        private void host_list(String NameLogFile)
        {

            const string listhost = "rpa_list2.txt";
            String TextLine = " ";
            // 1
            // Declare new List.
            List<string> HostInformation = new List<string>();


            // 2
            // Use using StreamReader for disposing.
            using (StreamReader r = new StreamReader(listhost))
            {
                // 3
                // Use while != null pattern for loop
                string line = " ";
                long Countline = 0;
                while ((line = r.ReadLine()) != null)
                {

                    //count the farst word for not count 
                    //
                    // Split string on spaces.
                    // ... This will separate all the words.
                    //

                    int CountWord = 0;
                    string[] words = line.Split(';');
                    String IP = "";
                    String type = "";
                    String userName = "";
                    String password = "";
                    foreach (string word in words)
                    {

                        if (CountWord == 0)
                        {
                            //not show this line 
                            if (word.IndexOf("#") != -1)
                            {
                                Countline = Countline - 1;
                                break;
                                //Console.WriteLine(word);
                            }
                        }


                        switch (CountWord)
                        {
                            case 0:
                                IP = word;

                                break;
                            case 1:
                                type = word;
                                if (type == "RPA")
                                {
                                    TextLine = TextLine + IP + Environment.NewLine;
                                    listBox1.Items.Add(IP);
                                }
                                break;
                            case 2:
                                userName = word;
                                break;
                            case 3:
                                password = word;
                                break;
                            default:
                                MessageBox.Show("Invalid selection. Please select 1, 2, or 3.");

                                break;
                        }




                        //     Lines[Countline] = IP;


                        CountWord = CountWord + 1;
                    }

                    // 4
                    // Insert logic here.
                    // ...
                    // "line" is a line in the file. Add it to our List.
                    //HostInformation.Add(line);

                    Countline = Countline + 1;
                }

            }

            //    return HostInformation;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            //create The core file
            bat_file.executeBatchFile("log_find_core_file.bat");
            add_core_name_to_listbox2();
            if (listBox1.Items.Count != 0)
                listBox1.SelectedIndex = listBox1.Items.Count - 1;
          //  button4.Visible = false;
            label3.Text = "Step 2 : press on the core that you want to open as BT ";
        }

        private void listBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            button2.Visible = true;
            button3.Visible = true;
            label3.Text = "step 3 : press on the 'select core' button ";
        }

        private void button2_Click(object sender, EventArgs e)
        {
            string RPAItem = listBox1.SelectedItem.ToString();
            string CoreItem = listBox2.SelectedItem.ToString();
            create_file_BT(RPAItem, CoreItem);
            label3.Text = "step 4 : press on the 'open folder for see the file' button ";
        }
        private void create_file_BT(String RPA, String core_name)
        {

            String file_name_BT = "";
            string[] words = core_name.Split(' ');
            int last_word = words.Length - 1;
            string[] path_core = words[last_word].Split('/');
            int last_path = path_core.Length - 1;
            for (int i = (last_word - 1); i >= 0; i--)
            {
                file_name_BT = words[i] + "_" + file_name_BT;

            }
            file_name_BT = file_name_BT + "_" + path_core[(last_path - 1)] + "_" + path_core[last_path];
            file_name_BT = file_name_BT.Replace(":", "_");

            switch (path_core[(last_path - 1)])
            {
                case "management":
                    bat_file.WriteLogFile(RPA, "management_server", words[last_word], file_name_BT);
                    break;
                case "replication":
                    bat_file.WriteLogFile(RPA, "replication", words[last_word], file_name_BT);

                    break;
                case "control":
                    bat_file.WriteLogFile(RPA, "control_process", words[last_word], file_name_BT);

                    break;
                case "cli":
                    bat_file.WriteLogFile(RPA, "cli", words[last_word], file_name_BT);


                    break;
                case "splitter":
                    bat_file.WriteLogFile(RPA, "splitter", words[last_word], file_name_BT);


                    break;
                case "mirror":
                    bat_file.WriteLogFile(RPA, "mirror", words[last_word], file_name_BT);


                    break;
                case "klr":
                    bat_file.WriteLogFile(RPA, "klr", words[last_word], file_name_BT);
                    break;
                case "storage":
                    bat_file.WriteLogFile(RPA, "storage_process", words[last_word], file_name_BT);
                    break;
                case "site_connector":
                    bat_file.WriteLogFile(RPA, "site_connector", words[last_word], file_name_BT);
  
                    break;
                default:
                    MessageBox.Show("need to add to the list of core");

                    break;
            }
            bat_file.executeBatchFile("plink.bat");
        }

        private void button3_Click(object sender, EventArgs e)
        {
            String pathFile = Application.StartupPath + "\\" + listBox1.SelectedItem.ToString();
            //     pathFile = "'" + pathFile+ "'";

            Process.Start("explorer.exe", @pathFile);

        }

        private void button4_Click(object sender, EventArgs e)
        {
            String pathFile = Application.StartupPath + "\\" + "rpa_list2.txt";

            Process.Start("notepad.exe", @pathFile);


        }

        private void button4_MouseEnter(object sender, System.EventArgs e)
        {
            // Update the mouse event label to indicate the MouseLeave event occurred.
            listBox1.Items.Clear();
            host_list("rpa_list2.txt");
            if (listBox1.Items.Count != 0)
                listBox1.SelectedIndex = listBox1.Items.Count - 1;
        }

        private void button_Analysis_Click(object sender, EventArgs e)
        {
            //create The core file
            bat_file.executeBatchFile("log_find_core_file.bat");
            add_core_name_to_listbox2();
            if (listBox1.Items.Count != 0)
                listBox1.SelectedIndex = listBox1.Items.Count - 1;
         //   button4.Visible = false;
            bat_file.executeBatchFile("Analysis_read_zip_All_file.bat");
            label3.Text = "Step 2 :Press on the core, you want to open as BT.You can see the Analysis by open folder";
            button3.Visible = true;
        }

        private void add_core_name_to_listbox2()
        {
            listBox1.Items.Clear();
            host_list("rpa_list2.txt");
            foreach (string s in listBox1.Items)
            {
                const string listCore = "core.txt";
                String pathFile = Application.StartupPath + "\\" + s + "\\" + listCore;
                String TextLine = " ";
                using (StreamReader r = new StreamReader(pathFile))
                {
                    while ((TextLine = r.ReadLine()) != null)
                    {
                        //add the name to listBox2
                        string sub = TextLine.Substring(23, TextLine.Length - 23);
                        listBox2.Items.Add(sub);

                        //   String pathFile = Application.StartupPath + "\\" + line;
                    }
                    //    
                }
            }
        }

        private void listBox2_DoubleClick(object sender, EventArgs e)
        {

            
         //   string[] words = core_name.Split(' ');
        //    int last_word = words.Length - 1;
        //    string[] path_core = words[last_word].Split('/');

            string RPAItem = listBox1.SelectedItem.ToString();
            string CoreItem = listBox2.SelectedItem.ToString();
            string[] words = CoreItem.Split(' ');
            int last_word = words.Length - 1;

//            int commaPos = words[last_word].IndexOf(',');
  //          if (commaPos != -1)
   //             string path_core = words[last_word].Substring(0,5);
     //       (0, commaPos)

           //     TrimEnd('/');
          string  path_core = Path.GetDirectoryName(words[last_word]);
            path_core = path_core.Replace('\\', '/');
            string to_execute = "kitty.exe -ssh root@" + RPAItem + " -pw q -cmd \"cd " + path_core + "; ls -lat \"";
            //ls -t | grep -B 1 core.8311 | grep -v core.8311 | xargs zless | grep -B 10 HERE
            //                string to_execute = "kitty.exe -ssh root@10.108.112.120 -pw q -cmd \"cd /home/kos/control; ls -lat\"";

            bat_file.executeCMD(to_execute);

        }
    }
}
