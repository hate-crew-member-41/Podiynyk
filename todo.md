# UI

## Entity actions

Make them modify the UI.

All entities:
- creating and deleting ➔ the list
- adding a label ➔ the tile

Events:
- new date ➔ the tile

Subjects:
- new event ➔ the list, the page, the tile

Students:
- new role ➔ the page, the tile

## Identification

Change the data source to https://registry.edbo.gov.ua/opendata/universities

## Leader election

If the user has specified a wrong group, they are trapped at this step forever.
Provide an ability to go back to the identification step.

## Appearance

What is shown instead of entity tiles:
- when they are being fetched
- if there are none

The loading screen. Try to also hide the fetches behind it, not just the storage initialization. Consider animating into the user's style as soon as the local storage has been initialized.

### Ideas	

New-entity pages appear as a page to the right of the section. Remember to remove the empty tiles.

Once the entities are fetched, each tile fades in with a different delay.

Entity fields are prefixed with icons.

New-entity pages are closed with an animation.

## Tour

Besides from being available in the settings, when should it be shown for the first time? Before or after the identification?

## Uncaught errors

Come up with a way to display them. They are possible here:
- main.dart
- ui\main\main.dart
- ui\main\identification.dart
- ui\main\group_zone\leader_election.dart
- ui\main\group_zone\home\home.dart
- ui\main\group_zone\home\sections\section.dart
- ui\main\group_zone\home\sections\agenda.dart
- ui\main\group_zone\home\sections\new_entity_pages\event.dart

# Firestore cloud functions

## Leader election

As soon as it is clear who is the leader, assign roles to the students (confirmationCount ➔ role) and initialize the group's entity documents (events, subjects, messages).

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

Messages that require an answer. After the user has answered, the answers of the group's students become visible on the page.

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