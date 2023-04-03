# funkcionalis_nyelvek_2
ELTE-IK functional languages 2 subject materials

All tasks are in Erlang.
To be honest I don't even know what these were about. There are some basic tasks, for example fibonacci or other recursion based functions.

### Sequential coding
The XOR task was about sequential programming in erlang.
It's basically XOR coding texts, helper functsions, decryption, encryption, etc.

### Parallel coding
The parjav and cache erlang files are about parallel programming. One is a fibonacci variation where it caches the already calculated values.
The other is a parallel any function, which starts as many processesses as there are items in the given array.

### Distributed coding
The warehouse and taskfarm tasks were about distributed programming, although the taskfarm was not finished.
In the warehouse task, a drug cartel is simulated. The bad guys arrive, the guards spot them and catch them, or they get away, etc.

### Server-Client
Well it's basically a sequential thing, but it's a server-client chat "application". (In the chat folder)
- Start it with name if you run both on the same computer (-sname server@gepnev)
- Local registered name -- global name ({chatsrv, 'server@gepnev'})

- Running on differenc computers: run it with name and ip (-name server@157.181.161.25)
- Same cookie (erlang:set_cookie(node(), alma) or -setcookie something)
