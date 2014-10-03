validation
==========

Source code for validation

The Schematron files are here. All of the tests are broken out into individual .sch files that are called into the main Schematron file(s). 

These individual test files are written into the modules directory. The tests are grouped together by Topic and error level. For example, we have permissions-errors.sch, permissions-warnings.sch, and permissions-info.sch. All three run tests on permissions, but the permissions-errors reports only those things that are errors. 


jats4r-errlevel-0.sch:
----------------------
The tests can be run with jats4r-errlevel-0.sch (which calls in all of the modules). They are grouped in the main Schematron file by level of reporting. When you run jats4r-errlevel-0.sch with the phase=errors, you will only run the error tests. This would give us a pass/fail for the article. 

When you run the jats4r-errlevel-0.sch with the phase=warnings, you will run the error and the warning tests, and when you run it with phase=info (or phase=#ALL) you will run all of the tests. The default phase is set to "errors", so if you just run it, it will act as a strict validator. 


jats4r-topic-0.sch:
----------------------
The tests can also be with jats4r-topic-0.sch (which calls in all of the modules). They are grouped in the main Schematron file by topic (math and permissions for now). When you run jats4r-topic-0.sch with the phase=permissions, you will only run the permissions tests.  

When you run the jats4r-topic-0.sch with the phase=math, you will run the math tests.There is no default phase. If you run it with phase=#ALL or no phase, it should run all of htests. When run this way, it will give the same result as  jats4r-errlevel-0.sch run with phase=info or #ALL.



