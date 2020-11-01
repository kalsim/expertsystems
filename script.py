import csv
def read():
   data = list(csv.reader(open("/Users/montek.kalsi/Desktop/animals.csv")))
   newfile = open("/Users/montek.kalsi/Desktop/out.txt", "w+")
   for i in range(1, len(data)):
      newfile.write("(defrule " + data[i][0] + "\n")
      for j in range(1, len(data[i])):
         newfile.write("   (" + data[0][j] + " " + data[i][j] + ")" + "\n")
      newfile.write("=>" + "\n")
      newfile.write("   (printout t \"The animal is a " + data[i][0] + ".\" crlf)" + "\n")
      newfile.write(")" + "\n")
      newfile.write("\n")
        

read()
