# App

## Reacting

Make the UI react to the following changes.

All entities:
- deleting ➔ the list
- adding a label ➔ the tile
- hiding/showing ➔ the actions

Events:
- new date ➔ the tile
- gets/loses the note ➔ the actions

Subjects:
- new event ➔ the list, the page, the tile

Students:
- new role ➔ the page, the tile

Just after the entity has been added, the section updates. Why does the section show for a moment that it awaits,
even though the future has already been awaited for, before the section was even notified it needs to update.

## Before Home

Make sure that it is safe for the user to do something wrong.

Make sure that if the app is closed, the right page is displayed when it is opened.

Try to also hide all required fetches behind the loading screen, not just the storage initializations.
Consider animating into the user's style as soon as the local storage has been initialized.

## Student names

When the user is at the identification step, they can enter any name. What if the name has already been entered?
The same question is relevant when the user changes their name later.

## Appearance

What is shown instead of entity tiles:
- when they are being fetched
- if there are none

What is shown instead of the entity's details while they are being fetched.
How they enter the page.

The loading screen.

### Ideas

If the user attempts to add an entity with some required fields unfilled, show a SnackBar with this information,
or color the fields and made the color fade out.

When the user uses the go-forward gesture and what comes next depends on the result of a future,
show a SnackBar to show that something is being done. As it is now, it looks as if nothing happens for some time.

New-entity pages appear as a page to the right of the section.
Remember to remove the empty tiles.

Once the entities are fetched, each tile fades in with a different delay.

Entity fields are prefixed with icons.

New-entity pages are closed with an animation.

## Tour

Besides from being available in the settings, when should it be shown for the first time?
Before or after the identification?

## Uncaught errors

Come up with a way to display them. They are possible here:
- main.dart
- ui\main\main.dart
- ui\main\identification.dart
- ui\main\group_zone\group_zone.dart
- ui\main\group_zone\leader_election.dart
- ui\main\group_zone\home\home.dart
- ui\main\group_zone\home\sections\section.dart
- ui\main\group_zone\home\sections\new_entity_pages\event.dart

# Firestore cloud functions

## Leader election

As soon as it is clear who is the leader, assign roles to the students (confirmationCount ➔ role).

## Maintaining

Clean the past events every midnight.

Update the message's author field if the author has changes their name.

Clean the old groups biannually.

# Ideas

## Settings

The language. Ukrainian, English, Polish? are available.

The theme. Let set the main color and infer the accent and content colors from it.

Opening the tour. Consider making it possible to open a specific page.

Changing the group.

## Notifications

## Questions

Messages that require an answer. After the user has answered, all the answers are displayed on the page.

## Queues

# Changes

## Entity details

They can be stored with the essential information.

### Advantages

1 read per collection of entities, no matter how many of them are opened.

The code is simplified immensely.

The entity page is not changed after it's been opened.

### Warnings

Unused data is fetched.

### Notes

Subject info labels are deleted in the Cloud with the subject labels.

Entities get [_wasModified] field and [sync] method that will update the entity instead of the setters.