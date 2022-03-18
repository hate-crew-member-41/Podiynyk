# App

## Before Home

Take time to come up with a better version of identification step.

Make sure that it is safe for the user to do something wrong.

Make sure that if the app is closed, the right page is displayed when it is opened.

## Reacting

Make the UI react to changes.

All entities:
- creating and deleting ➔ the list
- adding a label ➔ the tile
- hiding/showing ➔ the actions

Events:
- new date ➔ the tile
- gets/loses the note ➔ the actions

Subjects:
- new event ➔ the list, the page, the tile

Students:
- new role ➔ the page, the tile

## Entity pages

The changes are applied when the page is closed. Is the code for it written the best it can be?

## Appearance

What is shown instead of entity tiles:
- when they are being fetched
- if there are none

The loading screen. Try to also hide the fetches behind it, not just the storage initializations.
Consider animating into the user's style as soon as the local storage has been initialized.

### Ideas

If the user attempts to delete a subject with events, show a SnackBar instead of the dialog.

If the user attempts to add an entity with some necessary fields left empty,
show a SnackBar with this information.

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