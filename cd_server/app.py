from flask import *
import json
import mysql.connector
mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="14072003jp",
    database="cd"
)
cursor = mydb.cursor()
app = Flask(__name__)
@app.route('/displaystudents',methods=['POST'])
def displaystudents():
    print("hai")
    returner ={}
    returner['status']="false"
    registerNumber = request.json["regno"]
    print(registerNumber)
    query = f'SELECT * FROM studentdetails WHERE regno={registerNumber}'
    cursor.execute(query)
    details = cursor.fetchall()
    if details:
        returner['status']='true'
        students = []
        for s in details:
            student={}
            student["regno"]=s[0]
            student["name"]=s[1]
            student["course"]=s[2]
            student["stream"]=s[3]
            student["year"]=str(s[4])
            students.append(student)
        returner['details']=students
    print(returner)
    return returner

@app.route('/updatedetails',methods=['POST'])
def updatedetails():
    returner ={}
    registerNumber = request.json["regno"]
    name = request.json["name"]
    course = request.json["course"]
    stream = request.json["stream"]
    year = int(request.json["year"])
    print(registerNumber,name,course,stream,year)
    cursor.execute("UPDATE studentdetails SET name=%s, course=%s ,stream=%s ,year=%s WHERE regno = %s",(name,course,stream,year,registerNumber))
    mydb.commit()
    return returner

if __name__ == "__main__":
    app.run(host="0.0.0.0",port=(2003),debug=True)