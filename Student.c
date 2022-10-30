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
#include<string.h>
#include<stdlib.h>

struct Student {
    char SID[13];
    char NAME[25];
    char BRANCH[5];
    short int SEMESTER;
    char ADDRESS[15];
};

FILE *fp;

void insertStudent() {
    fp = fopen("StudentDetails.txt","a");
    if (fp == NULL)
    {
        printf("Error....!");
        return;
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
    fp = fopen("StudentDetails.txt","r");
    if (fp == NULL)
    {
        printf("Error....!");
        return;
    }
    fseek(fp,0,SEEK_END);
    printf("Number of records found: %ld\n",(ftell(fp)/sizeof(struct Student)));
    rewind(fp);
    while(fread(&student,sizeof(student),1,fp)) 
    {
        printf("Name: %s",student.NAME);
        printf("\tStudent ID: %s",student.SID);
        printf("\tBranch: %s",student.BRANCH);
        printf("\tSemester: %d",student.SEMESTER);
        printf("\tAddress: %s\n",student.ADDRESS);
    }    
    fclose(fp);
}

void listStudentsCSE()
{
    struct Student student;
    int found = 0;
    fp = fopen("StudentDetails.txt","r");
    if (fp == NULL)
    {
        printf("Error....!");
        return;
    }
    while(fread(&student,sizeof(student),1,fp)) 
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
    if (fp == NULL)
    {
        printf("Error....!");
        return;
    }
    while(fread(&student,sizeof(student),1,fp)) 
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
    struct Student student, modifyStudent;
    int found = 0;
    char ID[13], newAddress[25];
    fp = fopen("StudentDetails.txt","r");
    FILE *temp = fopen("temp.txt","a");
    if (fp == NULL || temp == NULL)
    {
        printf("Error....!");
        return;
    }
    printf("Enter student-ID: ");   scanf("%s",ID);
    while(fread(&student,sizeof(student),1,fp))
    {
        if(strcmp(student.SID,ID) == 0)
        {
            found = 1;
            printf("Enter new address: ");  scanf("%s",newAddress);
            strcpy(modifyStudent.SID,student.SID);
            strcpy(modifyStudent.NAME,student.NAME);
            strcpy(modifyStudent.BRANCH,student.BRANCH);
            modifyStudent.SEMESTER = student.SEMESTER;
            strcpy(modifyStudent.ADDRESS,newAddress);
        }
        else
        {
            fwrite(&student, sizeof(student),1,temp);
        }
    }
    fclose(fp);
    fclose(temp);
    if (!found)
        printf("No records found with Student-ID: %s\n",ID);
    else
    {
        fp = fopen("StudentDetails.txt","w");
        temp = fopen("temp.txt","r");
        printf("Record updated successfully\n");
        fwrite(&modifyStudent, sizeof(modifyStudent),1,fp);  
        while(fread(&student,sizeof(student),1,temp))
        {
            fwrite(&student, sizeof(student),1,fp);
        } 
        fclose(fp);
    } 
    remove("temp.txt");
}

void deleteStudent() 
{
    struct Student student;
    int found = 0;
    char ID[13];
    fp = fopen("StudentDetails.txt","r");
    FILE *temp = fopen("temp.txt","w");
    if (fp == NULL || temp == NULL)
    {
        printf("Error....!");
        return;
    }
    printf("Enter student-ID: ");   scanf("%s",ID);
    while(fread(&student,sizeof(student),1,fp)) 
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
    if (!found)
        printf("No records found with Student-ID: %s\n",ID);
    else
    {
        printf("Record deleted successfully\n");
        remove("StudentDetails.txt");
        rename("temp.txt","StudentDetails.txt");
    }    
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

void main() {
    fp = fopen("StudentDetails.txt","w");
    mainMenu();
    fclose(fp);
}
