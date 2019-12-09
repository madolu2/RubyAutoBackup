#Backup System
#1.The program creates backup copies of the selected
#directory and places it in the specified location.
#2. Writes his actions  to a log file.

def HashFill(source_path)
  Dir.foreach(source_path) do |file|
    if file != '..' and file != '.'
      $mtime[file] = File.mtime(source_path + file)
    end
  end
end

def CopyFile(source_path, target_path)
  File.open(target_path, 'w')

  File.foreach(source_path) do |line|
    File.open(target_path, 'a') do |file|
      file.puts line
    end
  end
end

def BackupFunc(source_path, target_path, user_action = false)
  Dir.foreach(source_path) do |file|
    if file != '..' and file != '.'
      if File.mtime(source_path + file) > $mtime[file]
        $mtime[file] = File.mtime(source_path + file)

        CopyFile(source_path + file, target_path + file)

        File.open($log_file, 'a') do |logfile|
          if user_action == false
            logfile.puts "#{Time.now} Auto backup"
            puts "auto backup"
          else
            logfile.puts "#{Time.now} User backup"
            puts "DONE\n"
          end
        end
      end
    end
  end
end

$mtime = Hash.new #Hash file last change date
$log_file = "/home/madolu2/RubyAutoBackup/logfile.txt"#Logfile.txt path
threads = [] #Threads array
sleep_time = 5*60 #Sleep timer for BackupFunc()
source_path = "/home/madolu2/RubyAutoBackup/source/"#Ur source directory
target_path = "/home/madolu2/RubyAutoBackup/target/"#Ur target directory

HashFill(source_path)#Fill $mtime hash

threads << Thread.new {
  puts "AUTO BACKUP AFTER EVERY 10 MIN\n"
  while true
    puts "PRESS '>' TO BACKUP"

    user_choice = gets.chomp

    if user_choice == '>'
      BackupFunc(source_path, target_path, true)
    end
  end
}

threads << Thread.new {
  while true
    BackupFunc(source_path, target_path)
    sleep(sleep_time)
  end
}

threads.each {|t| t.join }
