/*
Consider a structure named Student with attributes as SID, NAME,
BRANCH, SEMESTER, ADDRESS.
Write a program in C/C++/ and perform the following operations using
the concept of files.
a. Insert a new student
b. Modify the address of the student based on SID
c. Delete a student
d. List all the students
e. List all the students of CSE branch.
f. List all the students of CSE branch and reside in Kuvempunagar.
*/

#include<stdio.h>
#include<stdlib.h>
#include<string.h>

struct Student {
    char SID[13];
    char NAME[25];
    char BRANCH[5];
    short int SEMESTER;
    char ADDRESS[15];
};

FILE *fp;
void mainMenu();

void main() {
    fp = fopen("StudentDetails.txt","w");
    mainMenu();
}

void insertStudent() {
    fp = fopen("StudentDetails.txt","a");
    if (fp == NULL)
    {
        printf("Error....!Exiting....");
        exit(0);
    }
    
    struct Student student;
    printf("\nEnter details of student\n");
    printf("Name: ");     scanf("%s",student.NAME);
    printf("Student-ID: ");     scanf("%s",student.SID);
    printf("Branch: ");     scanf("%s",student.BRANCH);
    printf("Semester: ");   scanf("%d",&student.SEMESTER);
    printf("Address: ");    scanf("%s",student.ADDRESS);

    fwrite(&student, sizeof(student),1,fp);
    fclose(fp);
}

void listStudents() {
    struct Student student;
    int count = 0;
    fp = fopen("StudentDetails.txt","r");
    fseek(fp,0,SEEK_END);
    printf("Number of records found: %ld\n",ftell(fp)/sizeof(struct Student));
    rewind(fp);
    while(fread(&student,sizeof(struct Student),1,fp)) 
    {
        printf("Name: %s",student.NAME);
        printf("\tStudent ID: %s",student.SID);
        printf("\tBranch: %s",student.BRANCH);
        printf("\tSemester: %d",student.SEMESTER);
        printf("\tAddress: %s\n",student.ADDRESS);
        count++;
    }
    if (count == 0)
        printf("No records found.....!\n");
    
    fclose(fp);
}

void listStudentsCSE()
{
    struct Student student;
    int found = 0;
    fp = fopen("StudentDetails.txt","r");
    while(fread(&student,sizeof(struct Student),1,fp)) 
    {
        if(strcmp(student.BRANCH,"CSE") == 0) 
        {
            printf("Name: %s",student.NAME);
            printf("\tStudent ID: %s",student.SID);
            printf("\tBranch: %s",student.BRANCH);
            printf("\tSemester: %d",student.SEMESTER);
            printf("\tAddress: %s\n",student.ADDRESS);
            found = 1;
        }    
    }
    if (!found)
        printf("No records of CSE students found.....!\n");
    fclose(fp);
}

void listStudentsCSEKuvempunagar()
{
    struct Student student;
    int found = 0;
    fp = fopen("StudentDetails.txt","r");
    while(fread(&student,sizeof(struct Student),1,fp)) 
    {
        if((strcmp(student.BRANCH,"CSE") == 0) && (strcmp(student.ADDRESS,"KUVEMPUNAGAR") == 0)) 
        {
            printf("Name: %s",student.NAME);
            printf("\tStudent ID: %s",student.SID);
            printf("\tBranch: %s",student.BRANCH);
            printf("\tSemester: %d",student.SEMESTER);
            printf("\tAddress: %s\n",student.ADDRESS);
            found = 1;
        }    
    }
    if (!found)
        printf("No records of CSE students residing in Kuvempunagar found.....!\n");
    fclose(fp);
}

void modifyAddress() 
{
    struct Student student;
    int found = 0;
    char ID[13];
    char newAddress[25];
    fp = fopen("StudentDetails.txt","r+");
    printf("Enter student-ID: ");   scanf("%s",ID);
    while(fread(&student,sizeof(struct Student),1,fp)) 
    {
        if(strcmp(student.SID,ID) == 0) 
        {
            printf("Enter new address: ");  scanf("%s",newAddress);
            fseek(fp,-sizeof(student.ADDRESS),SEEK_CUR);
            fputs(newAddress,fp);
            found = 1;
        }    
    }
    if (!found)
        printf("No records found with student-ID %s\n",ID);
    else
        printf("Address updated successfully\n");    
    fclose(fp);
}

void deleteStudent() 
{
    struct Student student;
    int found = 0;
    char ID[13];
    fp = fopen("StudentDetails.txt","r");
    FILE *temp = fopen("temp.txt","w");
    printf("Enter student-ID: ");   scanf("%s",ID);
    while(fread(&student,sizeof(struct Student),1,fp)) 
    {
        if(strcmp(student.SID,ID) == 0) 
        {
            found = 1;
        }
        else
        {
            fwrite(&student, sizeof(student),1,temp);
        } 
    }
    fclose(fp);
    fclose(temp);
    if (!found)
        printf("No records found with Student-ID %s\n",ID);
    else
    {
        fp = fopen("StudentsDetails.txt","w");
        temp = fopen("temp.txt","r");
        printf("Record deleted successfully\n");  
        while(fread(&student,sizeof(struct Student),1,temp))
        {
            fwrite(&student, sizeof(student),1,fp);
        } 
    }    
    fclose(fp);
    fclose(temp);
}

void mainMenu() {
    printf("\n****MAIN MENU****\nEnter\n1---->To insert a new student\n2---->To modify the address of the student based on SID\n3---->To delete a student\n4---->To list all the students\n5---->To list all the students of CSE branch\n6---->To list all the students of CSE branch and reside in Kuvempunagar\n7---->To display main menu\n0---->To quit\n");
    int choice;
    while (1)
    {
        printf("\nEnter your choice: ");  scanf("%d",&choice);
        switch (choice)
        {
            case 1: insertStudent();    break;
            case 2: modifyAddress();    break;
            case 3: deleteStudent();    break;
            case 4: listStudents();     break;
            case 5: listStudentsCSE();  break;
            case 6: listStudentsCSEKuvempunagar();  break;
            case 7: mainMenu();     break;
            case 0: exit(0);    
            default: printf("Invalid choice.....!"); break;
        }
    }
}


/*
-- Create a table for the structure Student with attributes as SID, NAME, BRANCH, SEMESTER, ADDRESS, PHONE, EMAIL, Insert atleast 10tuples and performthe following operationsusing SQL.
-- a. Insert a new student
-- b. Modify the address of the student based on SID
-- c. Delete a student
-- d. List all the students
-- e. List all the students of CSE branch.
-- f. List all the students of CSE branch and reside in Kuvempunagar.

CREATE DATABASE IF NOT EXISTS Students;

USE Students;

CREATE TABLE IF NOT EXISTS StudentRecords (
	SID TEXT NOT NULL,
    NAME TEXT NOT NULL,
    BRANCH TEXT NOT NULL,
    SEMESTER INTEGER,
    ADDRESS TEXT NOT NULL,
    PHONE LONG,
    EMAIL TEXT NOT NULL
);

INSERT INTO StudentRecords VALUES
("01JST20CS100", "Akshay", "CSE", 5, "MADIKERI", 1234567890, "AkshayMadikeri@gmail.com"),
("01JST20CS102", "Hemanth", "CSE", 5, "KUVEMPUNAGAR", 2345678910, "HemanthPai@gmail.com"),
("01JST20CS284", "Sharath", "CSE", 5, "BENGALURU", 3456789120, "SharathShetty@gmail.com"),
("01JST20CS184", "Sandeep", "CSE", 5, "UDUPI", 4567891230, "SandeepShenoy@gmail.com"),
("01JST20CS295", "Suraj Rao", "CSE", 5, "MOODABIDRE", "5678912340", "SurajRaoUppor@protonmail.com");

SELECT * FROM StudentRecords;

INSERT INTO StudentRecords VALUES
("01JST20CS117", "GopalKrishna Hegade", "ECE", 5, "SIRSI", "6789123450", "gopalkrishnaHegade100@gmail.com");

SELECT * FROM StudentRecords;

UPDATE StudentRecords SET ADDRESS = "MUMBAI" WHERE SID = "01JST20CS295";

SELECT * FROM StudentRecords;

DELETE FROM StudentRecords WHERE SID = "01JST20CS184";

SELECT * FROM StudentRecords;

COMMIT;

SELECT * FROM StudentRecords WHERE BRANCH = "CSE";

SELECT * FROM StudentRecords WHERE BRANCH = "CSE" AND ADDRESS LIKE "%KUVEMPUNAGAR%";
*/