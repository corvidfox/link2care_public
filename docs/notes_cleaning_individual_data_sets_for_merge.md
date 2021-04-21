Notes on cleaning individual L2C data sets for merging
================
Created: 2021-04-22 <br> Updated: 2021-04-22

# Why change the original variable names?

1.  The variable names weren’t used consistently across different L2C
    data sets.  
2.  The variable names weren’t very descriptive.

At first, my plan was to resist the urge to change them. My thought was
that I wanted the data that comes out of this file to have variable
names that match the variables names in the codebook files. Then I
realized, however, that none of the calculated variables will be in the
codebook files anyway. Also, there isn’t a codebook file for the
combined survey data set. So, we can go ahead and rename variables in
this file. We will either have to create a new codebook for the combined
data or just live without one.

Having said that, completely changing variable names (e.g., SQ\_2 to
hispanic) may not be appropriate for this file for a couple of reasons:
1. It isn’t necessarily a high priority for the team and we are on a
tight deadline.  
2. Others may not like the names I select. Instead of creating
descriptive variable names in this file, we can use descriptive variable
names in the individual analysis files as needed.

So, in this file, we will standardize names (e.g., drop
"\_V1“,”HEIGHT\_3") so that they are consistent across the various data
files and can be merged.

Additionally, we will: 1. Convert all variable names to lower, snake
case.  
2. Create all calculated/created variables using lower, snake case.

# Naming conventions

-   The typical way that variables are named in these data sets is:
    -   <abbreviated_tool_name><question_number>\[optionally:dummy\_variable\_lettered\]
        -   For example: BPM1\_V1, LSN3\_V1
    -   <abbreviated_tool_name>\_<question_number>\[optionally:dummy\_variable\_lettered\]
        -   For example: Screening Question 2 is named: SQ\_2
        -   OR: The dummy variable for the “EMAIL” Response to Screening
            Question 18 is: SQ\_18A
    -   Many questions also have the visit number embedded in the name.
        -   For example: Demographics question 1 is: DEM1V1.
    -   However, there are some exceptions to this rule - intentional or
        not.
        -   For example, the fifth MMSE question is: MMS4V
-   In order to improve consistency in the variable names, we will adopt
    the following convention:
    -   <abbreviated_tool_name>\_<question_number>\[optionally:dummy\_variable\_lettered\]
        -   dummy variables will be numbered a-z
        -   For example, sq12, t14a
    -   We will drop visit number from the variable name an use an
        explicit visit variable.
    -   Exceptions: Demographic variables that almost anyone should be
        reasonably able to understand without the codebook will be given
        intuitive, descriptive names (e.g., age, race, gender,
        marital\_status, etc.)

# Coercing categorical variables to factors

Originally, I was coercing categorical variables to factors in this
code. However, I decided not to do that anymore because it isn’t
necessarily a high priority for the team and we are on a tight deadline.
In fact, others may not even use R for analysis in which case the factor
information would be lost entirely. Instead, we can convert categorical
variables to factors in the individual analysis files as needed.

# NOTE on recoding 7, 9, 99, etc. to NA

Originally, I was converting 7, 9, 99, etc. to NA in this code. However,
I decided not to do that anymore because it isn’t necessarily a high
priority for the team and we are on a tight deadline. In fact, others
may want to be able to compare “Don’t know” and “Refused”, which
wouldn’t be possible if I convert them all to NA here. Instead, we can
convert 7, 9, 99, etc. to NA in the individual analysis files as needed.

Therefore, in this file, just clean up the variable names so that they
can be merged and create the calculated variables.

# Read-in variable names from codebook

Using this method, as opposed to typing the variable names in manually,
has a couple of advantages: 1. It greatly reduces the risk of typos. 2.
It clearly maps any changes between the original codebook name and the
new name being used. 3. It may potentially save some time.

## Instructions

-   Open the RTF version of the codebook (e.g., L2C\_V1 Codebook.RTF),
    which can be downloaded from the UDrive/Kiteworks.
-   Create a .docx version of the codebook using “save as” in Word.
-   Create a “cb\_col\_name” style to identify existing variable names
    -   Open styles pane, click “New Style…”
    -   Name the new style cb\_col\_name and change the text color to
        red (optional).
-   Create a “col\_name” style to identify new variable names
    -   Open styles pane, click “New Style…”
    -   Name the new style col\_name and change the text color to green
        (optional).
-   Start marking variable names as such
    -   Place cursor immediately after each variable name and press the
        return key. Each variable name needs to be on its own line.
    -   Place cursor in each variable name and change the style to
        cb\_col\_name in the styles pane.
-   Create new/alternate variable names
    -   Place cursor immediately after each variable name and press the
        return key again.
    -   Type the new/alternate variable names.
        -   Don’t worry about capitalization or underscores. We will fix
            that programmatically below.
        -   Do worry about correct spelling.
    -   Place cursor in each variable name and change the style to
        col\_name in the styles pane.
-   Use a similar procedure for section\_name
    -   Only include sections that actually have questions in them.
        -   For example, NOT Sect-24. NEGATIVE/POSITIVE AFFECT

## Assign keyboard shortcut to a style (optional)

-   In styles pane, click drop down arrow to the right of the style name
    (e.g., cb\_col\_name).
-   Click “Modify style…”
-   Click “Format” drop down in the bottom left corner of the dialogue
    box.
-   Click “Shortcut Key…”
-   Enter the new shortcut key in the “Press new keyboard shortcut:”
    box.
-   Click assign.
-   Save changes in the local file.
-   Click OK.
