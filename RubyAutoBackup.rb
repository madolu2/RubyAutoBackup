#Backup System
#1.The program creates backup copies of the selected
#directory and places it in the specified location.
#2. Writes his actions  to a log file.

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

      target_path += '/' + file
      source_path += '/' + file

      CopyFile(source_path, target_path)

      target_path = '/home/madolu2/RubySVN/target'
      source_path = '/home/madolu2/RubySVN/source'

      File.open($log_file, 'a') do |logfile|
        if user_action == false
          logfile.puts "#{Time.now} Auto backup"
          puts 'auto backup'
        else
          logfile.puts "#{Time.now} User backup"
          puts 'GOT IT'
        end
      end
    end
  end
end

$log_file = '/home/madolu2/RubySVN/logfile.txt'#Logfile.txt path
threads = []
sleep_time = 5*60

source_path = '/home/madolu2/RubySVN/source'#Ur source directory
target_path = '/home/madolu2/RubySVN/target'#Ur target directory

threads << Thread.new {
  puts "AUTO BACKUP AFTER EVERY 10 MIN\nPRESS '>' TO BACKUP"
  while true
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
