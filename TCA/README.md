# TCA

https://github.com/pointfreeco/swift-composable-architecture

- Not a SwiftUI Framework but wrotten with swiftUI in mind
- More than just a description of a pattern / how to solve a problem
- Is an actual framework, and can be applied to bigger than a single feature

- State
    - Where your data lives
    - State and view already bound
    - When the state is updated, the view gets rerendered

- Actions 
    - almost always described as an enum
    - only way for the view to interact with TCA code
    - add alert to notify child features of the parent
    
- Reducer
    - Contains State and Action
    - Will also have a result builder style(`some`)
    - The  reduce function takes an action and state
    - State is an  in out parameter -> can update state inline
    - In the reduce function you can change the State based  on the Action and the UI will get updates
    - Then the effect that is returned can then do other work e.g. async call
    
- Effect
    - often return `.none`
    
- Dependencies (is that a singleton pattern??)
    - built similar to @Environment but accessible everywhere, not just a view
    - 

It is possible to separate a live implementation from development




    


