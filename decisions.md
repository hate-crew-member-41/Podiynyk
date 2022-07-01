# Decisions


## What attributes does the user have besides the name?


### 1

An arbitrary username.

__-__
	no way to recover the password
	a person can create any number of accounts

### [2]

An email.

__+__
	done with `Firebase Authentication`
__-__
	a person can create any number of accounts with services that provide emails for a short period of time

### 3

A phone number.

__-__
	it appears there is no free solution


## When is an event deleted?


### 1

At midnight.

__-__
	not all students may be done with it

### 2

When the event is hidden by the last student.

__-__
	not all students may actively use the app

### [3]

At midnight of the next day.
On the last day of the event's life, a request can be made to keep it for 2 more days.
