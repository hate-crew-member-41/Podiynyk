# What attributes does the user have besides the name?


## 1

An arbitrary username.

### -
- no way to recover the password
- a person can create any number of accounts

## **2**

An email.

### +
- done with `Firebase Authentication`

### -
- a person can create any number of accounts with services that provide emails for a short period of time

## 3

A phone number.

### -
- it appears there is no free solution


# When is an event deleted?


## 1

At midnight.

### -
- not all students may be done with it

## 2

When the event is hidden by the last student.

### -
- not all students may actively use the app

## **3**

At midnight of the next day.
On the last day of the event's life, a request can be made to keep it for 2 more days.


# How is students-to-subjects relation stored?


## 1

A subject stores it's students in the details.

### -
- it is impossible to know which subjects are relevant to a user with 1 read

## **2**

A subject stores it's students.

## 3

A user stores their subjects.

### -
- it is impossible to know which students are relevant to a subject with 1 read

## 4

Subjects are stored per student in the group's students document.

### -
- the subject page requires 2 reads
