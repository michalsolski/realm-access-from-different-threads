This repository shows how to access realm database with different threads.
By default, any background operation in DispatchQueue could be assigned by OS to a different thread. This could lead to "Realm accessed from incorrect thread" error.
The main idea was to use only one thread for reading and writing objects and then passing them(mapped objects) between threads.

In unit tests, we use the main thread to validate storage behavior. You shouldn't be used the main thread for I/O operation in production code.
