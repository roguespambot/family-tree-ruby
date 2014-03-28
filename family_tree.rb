require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def menu
  puts 'Welcome to the family tree!'
  puts 'What would you like to do?'

  loop do
    puts 'Press a to add a family member.'
    puts 'Press l to list out the family members.'
    puts 'Press m to add who someone is married to.'
    puts 'Press s to see relatives of a person.'
    puts 'Press e to exit.'
    choice = gets.chomp

    case choice
    when 'a'
      add_person
    when 'l'
      list
    when 'm'
      add_marriage
    when 's'
      pick_family_member
    when 'e'
      exit
    end
  end
end

def add_person
  puts 'What is the name of the family member?'
  name = gets.chomp
  person = Person.create(:name => name)
  puts "Add parents? (Y/N)"
  if gets.chomp.upcase == 'Y'
    add_parents(person)
  end
  puts name + " was added to the family tree.\n\n"
end

def add_marriage
  list
  puts 'What is the number of the first spouse?'
  spouse1 = Person.find(gets.chomp)
  puts 'What is the number of the second spouse?'
  spouse2 = Person.find(gets.chomp)
  spouse1.update(:spouse_id => spouse2.id)
  puts spouse1.name + " is now married to " + spouse2.name + "."
end

def add_parents(person)
  list
  puts "Enter the number of the first parent:\n"
  print ">"
  parent1 = Person.find(gets.chomp)
  puts "Enter the number of the second parent:\n"
  print ">"
  parent2 = Person.find(gets.chomp)
  person.update(:parent1_id => parent1.id, :parent2_id => parent2.id)
  puts "#{person.name} is the kid of #{parent1.name} and #{parent2.name}"
end

def list
  puts "Here are all your relatives:\n"
  people = Person.all
  people.each do |person|
    puts "#{person.id.to_s}: #{person.name}"
  end
  puts "\n"
end

def pick_family_member
  list
  puts "\n\nEnter the number of the relative and I'll show you who they're related to."
  person = Person.find(gets.chomp)

  show_marriage(person)
  # show_parents(person)
  # show_grandparents(person)
  type = 'parent'
  generation = 0
  show_relatives(person, type, generation)

  type = 'kid'
  generation = 0
  show_relatives(person, type, generation)
  # show_grandkids(person)
end

def show_marriage(person)
  if person.spouse_id == nil
    puts "#{person.name} is unmarried."
  else
    spouse = Person.find(person.spouse_id)
    puts "#{person.name} is married to #{spouse.name}."
  end
rescue
  puts "Oops. Something went wrong with the show_marriage function."
end

# def show_ancestors(person, type, generation)
#   until generation == nil
#     if person.send("#{type}s".to_sym).count == 0
#       puts "#{person.name} has no #{type}s."
#       generation = nil
#     else
#       puts "\n\n#{person.name} has these #{type}s:"
#       person.send("#{type}s".to_sym).each { |type| puts type.name }

#       generation += 1
#       if generation == 1
#         type = "grand" + type
#       else
#         type = "great" + type
#         show_descendants(person, type, generation)
#       end
#     end
#   end
# rescue
#   puts "Oops. Something went wrong with the show_#{type}s function."
# end

def show_relatives(person, type, generation)
  until generation == nil
    if person.send("#{type}s".to_sym) == nil
      puts "#{person.name} has no #{type}s."
      generation = nil
    else
      puts "\n\n#{person.name} has these #{type}s:"
      person.send("#{type}s".to_sym).each { |type| puts type.name }

      generation += 1
      if generation == 1
        type = "grand" + type
      else
        type = "great" + type
        show_relatives(person, type, generation)
      end
    end
  end
rescue
  puts "Oops. Something went wrong with the show_relative function at generation: #{type}s"
end

# def show_parents(person)
#   if person.parents == nil
#     puts "#{person.name} does not have both parents in the database."
#   else
#     puts "\n\n#{person.name} has parents: "
#     person.parents.each { |parent| puts parent.name }
#   end
# rescue
#   puts "Oops. Something went wrong with the show_parents function."
# end

# def show_grandparents(person)
#   if person.grandparents == nil || person.grandparents.count != 4
#     puts "#{person.name} does not appear to have the correct number of grandparents. Please check parental associations."
#   else
#     puts "\n\n#{person.name} has grandparents: "
#     person.grandparents.each { |grandparent| puts grandparent.name }
#   end
# rescue
#   puts "\nOops. Something went wrong with the show_grandparents function."
# end

# def show_grandkids(person)
#   if person.grandkids == nil
#     puts "#{person.name} has no grandkids."
#   else
#   puts "\n\n#{person.name} has these grandkids:"
#   person.grandkids.each { |grandkid| puts grandkid.name }
# end
# rescue
#   puts "\nOops! Something went wrong with the show_grandkids function."
# end

menu
