//! # 文档注释
//! 
//! 该库用于文档注释的教学

/*! # 文档注释

 该库用于文档注释的教学 */

pub mod compute;

/// Add one to the given value and return the value
///
/// # Examples
///
/// ```
/// let arg = 5;
/// let answer = doc_comments::add_one(arg);
///
/// assert_eq!(6, answer);
/// ```
pub fn add_one(x: i32) -> i32 {
    x + 1
}

/** Add two to the given value and return a new value

```
let arg = 5;
let answer = doc_comments::add_two(arg);

assert_eq!(7, answer);
```

*/
pub fn add_two(x: i32) -> i32 {
    x + 2
}

/// Add one to the given value and return a [`Option`] type
pub fn add_three(x: i32) -> Option<i32> {
    Some(x + 3)
}

mod a {
    ///  Add four to the given value and return a [`Option`] type
    /// [`crate::MySpecialFormatter`]
    pub fn add_four(x: i32) -> Option<i32> {
        Some(x + 4)
    }
}

struct MySpecialFormatter;

#[doc(inline)]
pub use bar::Bar;

/// bar docs
mod bar {
    /// the docs for Bar
    pub struct Bar;
}
