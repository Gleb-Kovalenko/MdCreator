<div align="center" style="margin-top: 0px;">
<img src = "logo.png" />
</div>

<h1 align="center" style="margin-top: 0px;">MdCreator</h1>

<p align="center" style="margin-top: 0px;">Script to help create README.md files</p>

- [Features](#features)
- [Input data](#input-data)
- [How it works](#how-it-works)
- [Customise structre](#customise-structure)
- [How to run the script](#how-to-run-the-script)
- [Requirements](#requirements)
- [Communication](#communication)
- [Author](#author)

<h2 id="features">Features</h2>

- [x] Easy to customise output structure
- [x] High loyalty to input data
- [x] Easy to run (by terminal or by .command file)
- [x] Easily add new properties for fields

<h2 id="input-data">Input data</h2>

#### .tcbundle file content example:


```json
{
  "description" : "Core snippets for service layer and services in general. Here you can snippets for protocol classes declarations, DAO instances declarations, service instance declarations and etc.",
  "supported_languages" : [
    "any"
  ],
  "expanders" : [
    {
      "output_template" : "\/\/\/ `${name.ucfirst}Service` instance\n\/\/\/\n\/\/\/ It is a bunch of methods that works with `${name.ucfirst}PlainObject` structure.\n\/\/\/ Basically, services contains primitive CRUD actions or atomic business actions.\n\/\/\/ Every service must return only `AnyPublisher` type from any method or `ServiceCall` type\n\/\/\/ that fully compatible with `Combine` and `AnyPublisher`\n\/\/\/ \n\/\/\/ Services are classes or components that encapsulate the logic required to access data sources.\n\/\/\/ They centralize common data access functionality, providing better maintainability and decoupling\n\/\/\/ the infrastructure or technology used to access necessary data layer.\n\/\/\/\n\/\/\/ Almost always standard services include DAO and this lets you focus on the data persistence logic\n\/\/\/ rather than on data access plumbing\n\/\/\/\n\/\/\/ - seealso: `${name.ucfirst}PlainObject` structure\n\/\/\/ - seealso: `${name.ucfirst}ServiceImplementation` class\nprotocol ${name.ucfirst}Service {\n\n}",
      "is_enabled" : true,
      "name" : "Service protocol",
      "supported_languages" : [
        "any"
      ],
      "description" : "",
      "identifier" : "",
      "pattern" : "service_protocol ${name:identifier}"
    },
  ],
  "is_enabled" : true,
  "name" : "INCETRO – Services"
}
```

<h2 id="how-it-works">How it works</h2>

For the .tcbundle file that is specified, we will create an enum, with the above structure passed for us

**Enum:**

<details>

```swift

// MARK: - MdFileTemplate

enum MdFileTemplate: String, MdFileTemplateProtocol {
    
    // MARK: - Cases
    
    case header = "name :header :filename"
    case description = "description :header"
    case headerExpander = "/name"
    case syntaxExpander = "/pattern"
    case inputExampleExpander = "/pattern :modify $name"
    case outputExpander = "/output_template"
    
    // MARK: - MdFileTemplateProtocol
    
    var isFileHeader: Bool {
        rawValue.contains(":header")
    }
    
    var isFileName: Bool {
        rawValue.contains(":filename")
    }
    
    var mayRepeat: Bool {
        rawValue.contains(":repeat")
    }
    
    var needModifyParameter: Bool {
        rawValue.contains(":modify")
    }
    
    var cleanPath: String {
        String(rawValue.split(separator: " ")[0])
    }
    
    func text(with element: Any) -> String {
        switch self {
        case .header:
            return """
            # \(element)
            """
        case .description:
            return """
            \(element)
            """
        case .headerExpander:
            return """
            ------
            
            ### \(element)
            """
        case .syntaxExpander:
            return """
            Syntax:
            ```swift
            \(element)
            ```
            """
        case .inputExampleExpander:
            return """
            Input example:
            ```swift
            \(element)
            ```
            """
        case .outputExpander:
            return """
            Output:
            ```swift
            \(element)
            ```
            """
        }
    }
}

```

</details>

After running the script, we will get the following .md file. The "name" parameter will be "user"

**Result:**

<details>

# INCETRO – Services

Core snippets for service layer and services in general. Here you can find snippets for protocol classes declarations, DAO instances declarations, service instance declarations and etc.

------

### Service protocol

Syntax:
```swift
service_protocol ${name:identifier}
```

Input example:
```swift
service_protocol user
```

Output:
```swift
/// `UserService` instance
///
/// It is a bunch of methods that works with `UserPlainObject` structure.
/// Basically, services contains primitive CRUD actions or atomic business actions.
/// Every service must return only `AnyPublisher` type from any method or `ServiceCall` type
/// that fully compatible with `Combine` and `AnyPublisher`
/// 
/// Services are classes or components that encapsulate the logic required to access data sources.
/// They centralize common data access functionality, providing better maintainability and decoupling
/// the infrastructure or technology used to access necessary data layer.
///
/// Almost always standard services include DAO and this lets you focus on the data persistence logic
/// rather than on data access plumbing
///
/// - seealso: `UserPlainObject` structure
/// - seealso: `UserServiceImplementation` class
protocol UserService {

}
```


</details>

<h2 id="customise-structure">Customise structure</h2>

 - Cases in this enum responsible for connection between input data and output structure. Raw value - field name in input data
 - Cases in the enum can be given some properties (for example, "\:filename", "\:header", etc.). They should be separated by spaces and begin with "\:"

<h2 id="how-to-run-the-script">How to run the script</h2>

Just download this project and open the **run.command** file that stored in this project.

#### *About run file*:

This file has a value which you need to update:

 - FilesDir - a path where input data strored
 - SaveDir - a path where output files will save
 - Merge - indicates whether files should be combined into a single .md file
 - PushToGit - indicates whether README.md file should be push to git automatically
 - GitRep - git repository for push

There are also has a git part, responsible for pushing new snippets to the collection.
I highly recommend to check it and set it for your own.

<h2 id="requirements">Requirements</h2>

 - macOS 10.13+
 - Xcode 9.0
 - Swift 5

<h2 id="communication">Communication</h2>

 - If you found a bug, open an issue.
 - If you have a feature request, open an issue.
 - If you want to contribute, submit a pull request.

<h2 id="author">Author</h2>

Gleb Kovalenko, yourpendos@gmail.com
