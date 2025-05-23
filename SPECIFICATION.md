# NOTES.md Specification

**Version 0.1**

NOTES.md is a plain-text file format for writing notes, reminders, todos, tasks, and checklists using CommonMark.

## License

This specification is available under the [Open Web Foundation Agreement, Version 1.0](https://www.openwebfoundation.org/the-agreements/the-owf-1-0-agreements-granted-claims/owfa-1-0). The text may be found [online](https://github.com/Symbitic/noteboard/blob/main/SPECIFICATION.md) under a [Creative Commons CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) license.

## Preface

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://datatracker.ietf.org/doc/html/rfc2119).

This formal specification is based on the [CommonMark Specification](https://spec.commonmark.org/current/) with several [GitHub Flavored Markdown](https://github.github.com/gfm/) (GFM) extensions.

The phrase "**NOTES file**" means a file following the NOTES.md specification, regardless of the actual file name.

## File Format

The file extension SHOULD be `.md`. It is RECOMMENDED to have a single file named `NOTES.md` to avoid any ambiguities.

The file MUST be valid CommonMark, with certain [restrictions](#restrictions) applied.

There SHOULD be a newline at the end of the file.

## Title

A NOTES file MAY have an optional level one heading at the start of the file. If so, this is considered the "**title**" of the NOTES file and SHOULD NOT affect parsing of the rest of the file.

## Item

An *item* is the basic unit of organization in a NOTES file. The words "group" and "section" MAY be used as synonyms for "item".

Every NOTES file contains at least one item. If no level two headings are present in the file, the entire content SHALL be considered one item. All content between the beginning of the file and the first level two heading is implementation specific.

An item MAY have a title, identified by a level two heading. The item MUST NOT contain any headings equal to the heading level of its title. The title MUST contain only plain text and MUST NOT begin with a whitespace character.

All content after the title until the next level two heading or the end of the file (whichever comes first) SHALL be considered the item's "**text**". The words "description" and "content" MAY be used as synonyms for "text".

## Restrictions

The following restrictions MUST be followed:

- All links and images MUST be inline.
- All headings MUST be ATX headings (identified with `#`).
