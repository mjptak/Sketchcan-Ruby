# Need to now build this with functions to clean up the code"
# Goal is to randomize the inputs off of some centralized list
# that keeps track of how one is doing on a particular question
# or family of question knowledge
# need to do the mathjax thing as well within the webdialog
# Use the webdialog early to select number of questions
# and then randomize the questions (i think by nesting a loop)
# eventually it should start to have knowledge of things you have
# answered correctly and incorrectly -- groups would be coded with first letter
# need to randomize and select from database based on if they know it.
###########
#load 'c:\Users\mark ptak\javadevel\game01\game01code.rb'
############ this is the syntax from the ruby console
model = Sketchup.active_model
entities = model.entities
selection = model.selection
definitions=model.definitions
view=model.active_view
counter=1
questions=[]
timestart=Time.now
#the file structure needs to go to the right place
file = File.open("c:/Users/mark ptak/javadevel/game01/game01ques.txt","r")
#next lines reads a series of questions that have specific coding
#as well as answers this would need to be changed to hide the answers
#could probably read off of a server or better yet a website
while (line = file.gets)  
# puts "#{counter}: #{line}"
 instring=line.split(",")
 questions.push(instring)
counter = counter+1
end
puts counter-1
#the next area sets up one screen for a set of questions lets people see patterns"
wrong=[]
correct=[]
prompts = []
defaults=[]
for i in 0..questions.length-1 do
prompts.push(questions[i][1])
defaults.push(" ")
end
input=UI::inputbox(prompts,defaults,'This is the question')
correctcount=0
for i in 0..questions.length-1 do
input[i].strip!
questions[i][2].strip!
if input[i] == questions[i][2]
correctcount=correctcount + 1
correct.push(i)
else
wrong.push(i)
end
end
#puts "the number correct is #{correctcount}"
wronglen=wrong.length
#puts "the number wrong is #{wronglen}"
for i in 0..wronglen-1
#UI.messagebox("#{questions[wrong[i]][1]}")
end
fileout=File.new("c:/Users/mark ptak/javadevel/game01/game01queswrong.out","a")
fileout.puts "*****"
fileout.puts Time.now
for i in 0..wronglen-1
fileout.puts questions[wrong[i]][0]
fileout.puts input[wrong[i]]
end
fileout.close
corlength=correct.length
fileout=File.new("c:/Users/mark ptak/javadevel/game01/game01quescor.out","a")
fileout.puts "*****"
fileout.puts Time.now
for i in 0..corlength-1
fileout.puts questions[correct[i]][0]
end
fileout.close
timeend=Time.now
timedelt=timeend-timestart
timedone=Time.at(Time.now)
puts "On #{timedone} you answered #{corlength} correct and #{wronglen} wrong in #{timedelt} seconds"
#for i in 0..wronglen-1
#entities.add_instance(definitions[0],[0,0,i*10])
#end
#for i in 0..corlength-1
#entities.add_instance(definitions[0],[50,0,i*10])
#end
#########this stuff below is how communication occurs between ruby and javascript###
#########there is definitely some data conversion which needs to go on ######
#########here lies the potential of calling up a khan exercise#########
#########and perhaps getting some of the data from the program#######
wd=UI::WebDialog.new( 
	"My First WebDialog", true, "", 
	400, 300, 100, 100, false )
##the numbers above are locations
wd.add_action_callback("first_ac") do |js_wd, message|UI::messagebox( 'I\'m Ruby. JavaScript said: "' + message + '"' )
#the info first comes from java to ruby and then the reverse
#java to ruby can pass an array but ruby to java must be string
#you can then take it apart and reassemble it in java using a split command.
#there is probably a need to do this twice based on stripping points or lines out
#replyt = message
replyt = '1000,2000,3000,4000,5000,6000'
script = 'rubyReturned( "' + replyt + '" );'
	js_wd.execute_script( script )
	end

wd.set_file( "c:/Users/mark ptak/javadevel/game01/game01.html" )

wd.show()

#To do in end is to then build a structure foundation based on accumulation of knowledge
#Information would be color and shape coded.  Club Penguinesque.