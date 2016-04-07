#!/usr/bin/env ruby
#
#
#

require "bundler/setup"
require "mastercracker"
require 'highline/import'

def save_locks
    File.open('data/locks.yml', 'w') do |f|
        f.puts YAML.dump @locks
    end
end


puts
puts "\t---------------------------"
say("\t|Welcome to Master Cracker.|")
puts "\t---------------------------"
puts

@choice = ''
@locks = YAML.load_file("data/locks.yml")

def start
    choose do |menu|
        say("Choose a lock to work on.")
        menu.choice("Start a new lock") { new_lock }
        if (@locks.class != FalseClass)
            @locks.each do |lock|
                menu.choice(lock.name) {work_on(lock)}
            end
        end
        menu.choice(:quit) {exit}
    end
end


def new_lock
    @locks = Locks.new
    lock = Lock.new
    lock.name = ask("Please enter and name for your lock")
    @locks << lock
    save_locks
    puts "Lock saved."
    start
end

def work_on(lock)
    say("Working on lock, #{lock.name}")
    choose do |menu|
        menu.choice("Change name") {
            lock.name = ask("New name?")
            save_locks
            start
        }
        menu.choice("Enter sticking points") { 
            lock.sticking_points = ask("Enter 12 sticking points or a blank line to finish") do |q|
                q.gather = ""
            end
            lock.sticking_points.sort!
            save_locks
            find_last_digit(lock) if lock.sticking_points.size == 12
            work_on(lock)
        }
        menu.choice("Edit sticking points") { edit_sticking_points(lock)}
        menu.choice("Try combinations") { try_combos(lock) }
        menu.choice("Main menu") { start }
    end
end

def edit_sticking_points(lock)
    choose do |menu|
        lock.sticking_points.each do |sp|
            menu.choice(sp) {
                lock.sticking_points[lock.sticking_points.index(sp)] = ask("New sticking point:")
                lock.sticking_points.sort!
                find_last_digit(lock) if lock.sticking_points.size == 12
                save_locks
                work_on(lock)
            }
        end
        menu.choice("Add point"){
            lock.sticking_points << ask("Enter sticking points")
            save_locks
            edit_sticking_points(lock)
        }

        menu.choice("Back") { work_on(lock) }
    end
end

def find_last_digit(lock)
    if(lock.sticking_points.collect{|x| x[/\d+\.5/]}.compact.size == 7)
        whole_numbers = lock.sticking_points.reject{|x| x.match(/\.5/)}
        say("Choose the number that has a unique last digit")
        choose do |menu|
            whole_numbers.each do |number|
                menu.choice(number) { lock.last_number = number }
            end
        end
    else
        say("Only 5 sticking points should be whole numbers")
    end
    save_locks
    work_on(lock)
end

def try_combos(lock)
    if(lock.solutions.size > 0)
        say("#{lock.solutions.size} total combos")
        lock.solutions.each do |solution|
            works = ask(solution.combo.join(", ")) if solution.tried != 'y'
            solution.tried = 'y' if works == "n"
            if (works == 'y')
                solution.works = 'y' 
                say("All done!")
            end
            if works == 'q'
                save_locks
                work_on(lock)
            end
        end
    end
    [Locks::SET1, Locks::SET2, Locks::SET3, Locks::SET4].each do |set|
        if(set[2].include?(lock.last_number.to_i))
            set[0].each do |i|
                set[1].each do |j|
                    solution = Solution.new
                    solution.combo = [i.to_s, j.to_s, lock.last_number]
                    lock.solutions << solution
                end
            end
        end
    end
    save_locks
    
end


start



