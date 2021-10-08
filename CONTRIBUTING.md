# Contributing
Note, anything you implement that you are requesting to merge must be your work, no plagiarism allowed.
Further, once your code is merged, it will fall under the MIT License for usage.

## The Most Important Rule
In this repo, there are no mistakes, there are only learning opportunities. Life is not eternal,
so respect others at all times whether code reviewing, collaborating, or even engaging with community members
outside of this project. Finally, as titled, the most important rule is to just have fun coding!!   

## First time setup

### Install Dart
Follow the official Dart guide for getting Dart installed [here](https://dart.dev/get-dart).
 
### Get Repo Setup

#### With [Github CLI](https://cli.github.com/)
**Note:** say yes when prompted to clone your fork.
```bash
gh repo fork Hanbrolo117/DDSA
cd DDSA
pub get
```

#### Without Github CLI
1. Fork this [repo](https://github.com/Hanbrolo117/DDSA). 
Check out [this Github doc on forking](https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github/fork-a-repo)
 if you aren't sure how to fork a repo. 
2. clone to your machine:
    - If using ssh
       ```bash
      git clone git@github.com:your-github/DDSA.git
      cd DDSA
      pub get
       ```
   - If using https:
       ```bash
      git clone https://github.com/Hanbrolo117/DDSA.git
     cd DDSA
     pub get
       ``` 



## Creating your branch
The branch name should be the name of the algorithm, data structure, software design pattern, etc.
The name must be in all lowercase and words separated by dashes (i.e. `-`).
```bash
gco -b branch-name-here
```

## Implementing Your Work
- All file and folder names should be lowercased and words separated by underscores.
- If your work involves multiple files, then you should have a directory in the appropriate place that contains your files and
should be named with the same name as branch with the exception of the word spacing rules.
- You must Document your code following [Dart doc standards](https://dart.dev/guides/language/effective-dart/documentation).
- Your code must adhere to the [Dart Style Standards](https://dart.dev/guides/language/effective-dart/style).
- Whether 1 or more files, if you feel diagrams, readmes, etc. are needed, follow the rules for multi-file implementations
so that your supporting docs can reside with your work in a single folder.
### Testing
- Adequate unit tests should be written for your implementation.
- For each dart file being tested, the test name should be the same name as the dart file being tested
but with a postfix of`_test` added to it's name.   
- Unit tests live in the `test` folder,
which mimics the `src` foldertree.

#### Single file Example:
```yaml
# Project folder tree
lib
|___ src
     |___ sorting
          |___bubble_sort.dart
test
|___ sorting
     |___ bubble_sort_test.dart
```

#### Multi-file Example:
Note that note everything needs to be tested, e.g. node.dart
simply implements a pure PODO ( Plain old dart object) so there is no real story to test there.
In reality you could leave that in the `graph.dart` file if
you wanted, this is simply done for demonstration purposes, but know
that it is acceptable to pull something like that out it out into its own file if
desired, just know you need to follow this multi-file structure then.
```yaml
# Project folder tree
lib
|___ src
     |___ graphs
          |___ generic_graph
               |___ node.dart
               |___ graph.dart
               |___ sequenceDiagram.txt
               |___ sequenceDiagram.png
test
|___ graphs
     |___ generic_graph
          |___ graph_test.dart
```

### Diagramming
- If you wish to create umls, sequence diagrams for your work, this project encourages the use
of [PlantUml](https://plantuml.com/). It is a nice markdown language for defining various types of diagrams. Since Plantuml
is free to use, and is a markdown based diagram tool, it makes it easy for others who are learning to
open the file and easily play around with the diagram and learn. 
  - For any PlantUml diagrams both the markdown and the png generated from it must be committed into your
  branch's working directory.
  - To make it easy to view changes in markdown and generate your file, you can use the plugin for the following
  IDEs!
    - [Intellij IDEA](https://plugins.jetbrains.com/plugin/7017-plantuml-integration)
    - [VS Code](https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml)
- You are however of course free to use any diagram tool, however, if this is a proprietary tool, then
you must also commit the generated png file of your diagram for others to view, that is only providing a
proprietary file type of a uml design tool will not suffice as it limits those who do not have that tool
from viewing your work. 