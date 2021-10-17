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
First make sure you are signed into github cli
(I will show the options I usually use to auth be feel free to auth however you prefer)
```bash
gh auth login
? What account do you want to log into? GitHub.com
- GitHub.com
? How would you like to authenticate?
- Login with a web browser
? Choose default git protocol
- SSH
```
Now Fork the repo and clone it
<br>
(**Note:** say yes when prompted to clone your fork.)
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
# Formula:
git checkout -b branch-name-here
# Example, I want to implement Chain Of Responsibility Design Pattern by Gang of Four
git checkout -b chain-of-responsibility

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
- Once tests are written all unit test suites will need to be added to the ddsa_test.dart file
in order for CI to pass. Any maintainer code reviewing PRs will deny them from being merged until this is
done so.

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
Note that not everything needs to be tested, e.g. node.dart
simply implements a pure PODO ( Plain old dart object) so there is no real story to test there.
In reality you could leave that in the `graph.dart` file if
you wanted, this is simply done for demonstration purposes, but know
that it is acceptable to pull something like that out into its own file if
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

#### Adding unit test suites to the main test file.
```dart
// In the test/ddsa_test.dart file
import 'path/to/your/test_file.dart' as test_file;
void main() {
  // There will be other tests being executed here, just add a new line at the bottom and invoke your tests there.
  test_file.main();
}
```

#### Running your tests
To run the full test suite, run the following:
```bash
make test
```

#### Building for tests
While our project is about writing with pure dart and not leveraging packages for implementations, we do use a couple
packages to help out with testing. We utilize [test](https://pub.dev/packages/test) and
[mockito](https://pub.dev/packages/mockito) for writing our unit tests. With the advent of Dart 2.12 which introduces
Sound null safety, [mockito](https://pub.dev/packages/mockito) now requires consumers to depend on
[build_runner](https://pub.dev/packages/build_runner) to allow usages of its argument capturing features like `any`, to
for non-nullable parameters. It will generate code for any mocked files, check their
[null safety readme](https://github.com/dart-lang/mockito/blob/master/NULL_SAFETY_README.md) for how to properly mock
things that leverage Dart's null safety features.
<br><br>
Because of this, some tests may require a build to be run by build_runner.
<br><br>
##### To run a one-off build of your mockito test, run the following in the root directory of the project:
```bash
make build
```
<br><br>
##### To run a build that watches your code and runs after any changes are made for your mockito test, run the following in the root directory of the project:
```bash
make watch
```

### Formatting
To maintain a consistent formatting style across the code and test code, this repo follows the Dart formatting via it's
provided tooling. To format your code, simply run the following:
```bash
make format
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

## Code Reviews
- All unit tests created must be added to the `test/ddsa_test.dart` file.
- All diagrams added should use Plant Uml with the `.puml` and generated `.png` files committed.
- The PR Description must be properly filled out.
- Code must be passing CI
  - All code in `lib/` and `test/` must be formatted properly.
  - All tests must be passing