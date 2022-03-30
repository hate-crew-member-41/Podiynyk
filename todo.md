# App

Allow widgets to be present if they have no actual effect (GestureDetector, WillPopScope).

Make sure that too much of the widget tree is not rebuilt. Check:
- hooks: useState, useListenable
- context.watch

## Reacting

Make the UI react to the following changes.

All entities:
- hiding/showing ➔ the actions

Events:
- gets/loses the note ➔ the actions

Subjects:
- adding/deleting an event ➔ the list, the tile
- adding/deleting an info item ➔ the list

Students:
- new role ➔ the page, the actions

## Before Home

Make sure that it is safe for the user to do something wrong.

Make sure that if the app is closed, the right page is displayed when it is opened.

Try to also hide all required fetches behind the loading screen, not just the storage initializations.
Consider animating into the user's style as soon as the local storage has been initialized.

## Student names

When the user is at the identification step, they can enter any name. What if the name has already been entered?
The same question is relevant when the user changes their name later.

## Appearance

Highlight the tile of the current section.

What is shown when the entities are being fetched and if there are none.

What is shown instead of the entity's details while they are being fetched.
How they enter the page.

The loading screen.

The current typed word underlined. Words are not auto-capitalized.

Consider adding some automatic focus changes to new-entity forms.

The color of the selected-text toolbar.

### Ideas

If the user attempts to add an entity with some required fields unfilled, show a SnackBar with this information,
or color the fields and made the color fade out.

When the user uses the go-forward gesture and what comes next depends on the result of a future,
show a SnackBar to show that something is being done. As it is now, it looks as if nothing happens for some time.

New-entity pages appear as a page to the right of the section. Remember to remove the empty tiles,
and to only update the subject after the field has been pressed.

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

# Firebase

## Cloud Firestore

Consider indicating that an event does not belong to a subject bu not including the `subject` field at all.

Does EntityCollection need `detailsRef`?

## Cloud Functions

### Leader election

As soon as it is clear who is the leader, assign roles to the students (confirmationCount ➔ role).

### Maintaining

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