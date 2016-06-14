Apache Gearpump 0.8.0
==================

Apache Incubation:
-------------------
Apache Gearpump enters Apache incubation. Now, we are working on importing the source code to Apache Git (INFRA-11435), and
 a bunch of other tasks (GEARPUMP-1).

Apache Gearpump Jira: https://issues.apache.org/jira/browse/GEARPUMP
Mail list:

* Subscribe link to User list: user-subscribe@gearpump.incubator.apache.org
* Subscribe link to Dev list: dev-subscribe@gearpump.incubator.apache.org
* Subscribe link to Private list: private-subscribe@gearpump.incubator.apache.org
* Subscribe link to commits list: commits-subscribe@gearpump.incubator.apache.org

What are the changes for the process for Apache Incubation?
------------------
The code importing to Apache Git is still in process. During this transition time,
We will follow these procedures:

 1. For new issue, we should no longer open issue in Github issues. Instead, we
   need to open an issue at Apache Jira: https://issues.apache.org/jira/browse/GEARPUMP
 2. Pull Requests are still submitted to http://github.com/gearpump/gearpump for review.
 3. We should cross post the link of PR to Jira site, and Jira link to Pull Request context.
 4. Code will still be commited to https://github.com/gearpump/gearpump
 5. During this transition time, document change doesn't require a +1 if it comes from committers.
 6. The release tag requires a consensus in project discussion like sync-meeting. But it doesn't
   additional "+1" on code commit.
   For example, we will ask around that whether it is OK to trigger a tag; if every one agrees,
   then the assignee can tag the build and change the release doc directly without a written "+1" on the commit.

After the transition period, the proposed process is like this:

 1. The official repo will be at git://git.apache.org/gearpump.git, all other repos will be
    mirror of this repo.
 2. We will disable "write" in github issues, and switch to Apache Jira.
 3. We will enable Apache Github integration, which allow us to mirror official Git repo in Github.
 4. When the user submit a PR, there should be at least one +1 before doing merge.
 5. For all commits, the commit should commit the path manually to official repo
   git://git.apache.org/gearpump.git, "Github merge" will be disabled.
 6. For document change, we can have further discussion on whether it should requires a +1.

Before completing importing source code to Apache Git, we will still use

Why we make a tag release now, but not wait until Apache importing complete?
------------------
There are quite a lot of open task at https://issues.apache.org/jira/browse/GEARPUMP-1, which
would take a significant time. For example, we still don't have the new maven artifact yet.

Making incremental releases like this one allow us to be more prepared to make a full Apache release.

Highlights:
------------------
1. Update Akka to Akka 2.4.2 (#1988). Now we only support Java 8 and Scala 2.11, Java7, Scala 2.10 support is dropped
   (Be compatible with Akka 2.4.2). The performance of Gearpump 0.8.0 is as good at Gearpump 0.76.
2. Fix Min clock slow-advancing issue (#1318) when some graph edge (Possibly means networking between two hosts) don't
   have enough traffic.
3. Add OAuth2 social login for UI server.

Lowlights:
-------------------
Akka-stream DSL module is temporary disabled, as Akka-Stream 2.4.2 has big API change compared with Akka-Stream 1.0. We'd
like to add the full functional module back in next release.

Change log:
------------------
From now on, new issues should be submitted to https://issues.apache.org/jira/browse/GEARPUMP

- GEARPUMP-10, Downgrade netty from Netty 4 to Netty 3.8 cause the OAuth2 authentication failure
- GEARPUMP-9, Clean and fix integration test
- GEARPUMP-8, fix "two machines can possibly have same worker id for single-master cluster"
- GEARPUMP-6: show add/remove worker buttons for admin
- GEARPUMP-5, Add additional authorization check like checking user-organization for cloudfoundry OAuth2 Authenticator.
- GEARPUMP-3, Define REST API to add/remove worker instances, which allow us to scale out in YARN.
- GEARPUMP-2, Define REST API to submit job jar
- #1988, upgrade akka to akka 2.4.2
- #2015, do not send AckRequest or LatencyProbe when no pending messages
- #1943 allow user to config how many executors to use in an application
- #1641, add exactly-once it
- #1318, fix MinClock not updated fast enough for slow stream
- #1981, Support OAuth2 Social login
- #2007, add Java DSL
- #2002, add akka stream examples
- #1996, EmbeddedCluster requires master configuration like ClusterActorRefProvider.
- #1989: add confirmation dialog for kill app and restart app
- #1983, fix KafkaUtilSpec failure
- #1975,  fix storm integration test
- #1972, backoff retry kafka consuming on exception
- #1966 make Partitioner API Java compatible
- #1892: added instruction text to operate network graph (2) minor tweaks of context menu
- #1963, rename CommitGuideline.md to CONTRIBUTING.md
- #1958: better test report organizing
- #1906: some visual glitches found in mobile view

Gearpump 0.7.6
===================
Highlights:
-------------------
1. #1648 Support submit storm jar via dashboard
2. Support StreamCQL over Gearpump

Change log:
-------------------
- #1924, fix storm test spec failure
- #1926, fix client side configuration does not work in CGroup
- #1648, support submit storm jar via rest interface
- #1933, Fixes some of the documentation typos, adds SBT configuration
- #1936, allow user to config kafka source start offset time
- #1777, Dynamic DAG failed after changing parallelism for many times
- #1932, Fix client config overwrites critical system config
- #1895, make GearpumpNimbus a standalone service
- #1910, enlarge timeout in MasterClient
- #1952, document how to use StreamCQL over Gearpump

Gearpump 0.7.5
===================
Highlights:
-------------------
1. #1723, Add an experimental cgroup module for CPU isolation.
2. #1767, Add docs and implementation to support storm 0.10.
3. Make UI mobile phone friendly. 

Change log:
-------------------
- #1919, fix AppMasterSpec
- #1723 add an experiment module to do cgroup CPU isolation.
- #1913, add warning for detected loop in DAG.
- #1896, move storm examples under integration test
- #1897, increase akka logger start up timeout for unit test
- #1843 Add a Rest service to launch a new worker
- #1904, fixed "DAG canvas context menu cannot be displayed."
- #1898: in integration test, there need a retry attempting for login
- #1882: extract the tool tip string to externalized file
- #1837, Use java.net.preferIPv4Stack to force IPv4
- #1885, Shorten the table view when disabled in mobile.
- #1883,URL redirection error when accessing index.html
- #1874, Format the login failure message to more readable format.
- #1876, Shell command yarnclient should use 1 as the the default count for "addWorker"
- #1877, Fix several navigation issues on Mobile phone
- #1830: removed cluster side menu and tuned main navbar
- #1681: show application last error in overview page
- #1866, use geardefault.conf to replace reference.conf to avoid confusion
- #1767, Add docs and implementation to support storm 0.10
- #1868: show correct data points when switch historical view and recent view.
- #1864, Add robots.txt to disable search engine crawling
- #1860, add licenses for included source and binary libraries.
- #1804, fix UI authentication document page format

Gearpump 0.7.4
===================
Change log:
-------------------
- #1247, add authentication for UI
- #1855: when service is unavailable, do not query models without waiting.
- #1833 update performance related doc
- #1831, Services exits on bind failure
- #1779: show critical path latency for application 
- #1733 dynamic dag fall back to last dag version in case of Master HA
- #1804, fix navbar on mobile
- #1713 regression on HBaseSink
- #1838 YARN failure trying to contact YarnAppMaster when launched in YARN

Gearpump 0.7.3
===================
Change logs:
-------------------
- #1816: Akka GC problem. After fixing, performance gain 30%
- #1820, http cache is not effective
- #1817 Problems launching Gearpump in YARN environment

Gearpump 0.7.2
===================
Change logs:
-------------------
- #1814: metrics data will not update
- #1812 add gearpump.verbose-gc in gear.conf
- #1754, use scala binary version in example jar name
- #1804, polish documents
- #1803 fix performance regression

Gearpump 0.7.1
===================
Highlights:
-------------------
1. #1411. new UI experience. now the frontend UI can safely support applications with tens of thousands to tasks.
2. #1514 Add Akka-stream 1.0 experimental module
3. #1698, refactor on yarn experiment module, with bug fixes, and enhanced functions, like dynamically adding/removing machines.
4. #1679, fix dynamic dag bug (fail to transit)
5. #1547, add a SequenceFileSink

Change logs:
-------------------
- #1761, add more source comments and fix several typo
- #1799, amend two PROXY typos in files 
- #1411: new UI to allow to scale to thousands of tasks.
- #1794, split dispatchers of Task and Netty
- #1018 transfer Any in Message
- #1792, fix storm module config conflict
- #1785, [yarn] UI daemon process cannot be terminated
- #1789 fix DynamicDagSpec
- #1784, document the limitation of yarnclient command line.
- #1778, AppSubmitter "-config" option is not used
- #1782, add doc to run storm over Gearpump application on yarn
- #1774, remove MaxPermSize JVM option as JDK8 no longer support it.
- #1772, When upload application in UI, custom config file is not effective
- #1770, processor metrics is aggregated in wrong way
- #1768, TaskFilterAggregator is not working
- #1763, change all GearPump to Gearpump
- #1411: metrics charts would not update after 15 seconds
- #1756, add HistoryMetricsConfig for master info and worker info
- #1754 standardize archive name
- #1753 update server channel group name
- #1747: storm spec failure due to parse application id
- #1747: updated the way to parse application id in command-line
- #1743, fixing some typo in the example folder
- #1744, Separate global config and application specific config, allow to config log level for specific
 class.
- #1734, handle smoothly when more resources are allocated than required.
- #1698, refactor on gearpump-yarn experiment module
- #1716: enable code coverage check for master branch
- #1720, support automatic integration test
- #1719 unhandled PutKVSuccess in Master
- #1714: some navbar visual issues
- #1499, Aggregate the metrics on server
- #1711: layout is more responsive on small devices
- #1679 dynamic dag will fall back when replacing a processor failed
- #1707, support html test report in integration test
- #1670, regression, change taskActor back to use stashing.
- #1703: task metrics in bar chart were empty
- #1701: wrong dirty check of modify processor and more
- #1384: rest service url was not set correctly
- #1682: allow specify a transition time when changing parallelism
- #1691: dashboard layout and textual changes and update to dashing...
- #1640 YARN deployment - no easy way of obtaining master address...
- #1688, Reduce unimportant logs in travis UT console
- #1671, make default timeout shorter to be more UI responsive.
- #1685, Should not publish gearpump-integration-test to maven
- #1683, Allow metrics to be aggregated before sending to UI
- #1223: will mark application with a warning when stalling task de...
- #1670, #1653, fix dynamic dag bug
- #1659 add a rest api to terminate service process
- #1672: when worker is killed, its detail page will no longer be updated
- #1660 remove Try block,give debug info to user instead.
- #1666: will should application details (and load metrics afterwards)
- #1651, fix change processor's parallelism on dashboard
- #1536, fix storm at least once support
- #1655: added a test case for replacing a processor
- #1653 fix replacing a processor
- #1639 refine daemon's classpath
- #1652, submit app with no arguments from dashboard returns warning
- #1547 add a SequenceFileSink
- #1424: when application is terminated, related status indicators ...
- #1645: parse appid in submission response better
- #1514, add an experimental module to support akka-stream 1.0
- #1643, fix UI timeout issue when metrics is disabled
- #1632 Remove duplicate of repository
- #1630, StormBoltOutputCollector skips reporting on ack disabled

Gearpump 0.7.0
===================
Highlights: 
---------------
1. New end-to-end integration test, better test coverage (#1243 Thanks to contribution by Stanley, Tianlun, Huafeng, Kewei)
2. Storm binary compatibility. (still has some limitation)
3. New Document site(#1506).
4. Secure YARN and secure HBase support(#1458)
5. spray is replaced by akka-http (#1261)
6. New serialization implementation(#1445 allow user to custom a serialization framework).

Change log:
---------------------
- #1627, refine on custom serialization doc.
- #1624, fix the worker report resource timeout settings.
- #1384: removed wrong page redirection
- #1243: provide an integration test suite
- #1607 fix NONE_SESSION when restart tasks
- #1609, fix storm message timestamp bugs
- #1579 Additional documentation changes
- #1536, support storm ack
- #1581, fix HadoopCheckpointStore
- #1506 Totally reorganize documentation
- #1538 fix yarn application classpath
- #1519 fix performance regression
- #1485 no more pending messages in ExpressTransport
- #1458, enable secured HBase
- #1496, fix StormSerializer Kryo buffer overflow
- #1478: click on location button will copy text to clipboard
- #1491, fix ContainerLaunchContextSpec
- #1489, remove terminated executor from ExecutorManager
- #1481, improve storm over gearpump perf
- #1479: add uptime field in service interface
- #1481, fix storm performance
- #1482, fix TaskScheduler over schedules when multiple executors down at once
- #1458 support launching Gearpump in secured Yarn cluster
- #1476 fix serialization in transport layer
- #1470: updated a broken dashboard dependency
- #1463, fix storm config
- #1465 fix DistributedShell
- #1462 pass user config to SerializerPool
- #1453: allows use DEL to remove processor/edge- 
- #491: Added support for composing DAG from scratch
- #1449 fix copy file to local in LocalJarStoreService- 
- #1387 decouple serializer for Message
- #1445 refactor serialization implementation
- #1343, support Storm emitDirect and DirectGrouping
- #809: static resources are now sent to client gzipped
- #1438: polished modify processor dialog
- #1423: show full error log in a popup
- #1423: show error message when uploading is failed and polished the dialog
- #1430: turn off illegal header warning
- #1428, add unidoc plugin which allow us to build the scaladoc for the whole project(include all sub-projects)
- #1228, add data source and data sink for java api
- #1228, further simplify the java interface
- #1422: removed if-modified-since header. it is not relevant and is handled very different by different web servers
- #1228, add java interface for Graph API
- #1411: chart will always fill data points for 15 minutes
- #1261, #1127, replace spray with akka-http
- #1373 add duplicated edge detecting
- #1412: add 'no-cache' header in ajax responses
- #1194 add graph cycle detection
- #491, add a rest api to acquire Gearpump's built-in partitioners
- #1405: now the number of executors is back
- #1371: a right way to show historical metrics (2) added committedâ€? 
- #1402, fix NoneGroupingPartitioner
- #1399: in application overview page the task count of executor wa...
- #1397, allow KafkaSink to receive Message of bytes
- #1395, cross publishSigned
- #1374 remove jars of yarn in executor's classpath
- #1266: should exclude dead edges
- #1238, adds BroadcastPartitioner
- #1381 test on travis out of memory
- #1379, support storm tick tuple

Gearpump 0.6.1
==========================
Highlight: new version UI dashboard.

Change log:
--------------------
- #1369: object path and metrics name are divided by ':' now
- #1369: fixed data initialization issue of echart
- #1364, add default value for BYTES_PER_MESSAGE of SOLStreamProducer
- #1361: able to show multiple tasks in chart (better not select moâ€?
- #1358: properties will be updated (2) moved roboto font and echartâ€?  

Gearpump 0.6
==========================
Highlight: new version UI dashboard.

Change log:
--------------------
- #606: ui v2
- #1352, return appmaster config
- #1344 fix Master HA bug

Gearpump 0.5.0
==========================
Highlights:
----------------
1. Rename package name to io.gearpump

Change log:
----------------------
- #1341, Cannot submit application in UI if one master is killed and another master started

Gearpump 0.4.4
==========================
Highlights:
----------------
1. Allow user to change the DAG on the fly by providing a new jar.
2. Add hadoop storage for Transactional topology
3. shade environment dependencies jars.
4. Support scala 2.10 and scala 2.11

Change log:
----------------------
- #1339, metrics typo
- #1336, verbose log to console
- #1331, check whether we have duplicate metric before registering.
- #1330, Worker cannot init when setting HDFS as jarStore
- #1334, fix Storm LocalCluster dependencies
- #1324, tag storm tuple with timestamp
- #1246 isolate processors' classpath
- #1327, move project state and dsl to under streaming
- #924, fix storm wordcount example
- #1319 fix application HA not working
- #1315, fix clock stalling
- #1305 remove JarFileContainer, replace it with Path.
- #1313, fix 2.10 build failure
- #601, 1. add jvm metrics 2. add master and worker metrics.
- #1296, enable cross compile and publish
- #606, add more rest service for new UI(version 2)
- #1013, track task checkpoint time at ClockService
- #1301, fix state example tests
- #339, add Hadoop-compatible CheckpointStore
- #1278, Optimize the build script for scalajs.
- #1285, fix travis deploy build script
- #1241 shade akka-kryo-serialization
- #1278 split services into 2 projects for scala.js
- #1290, purify state dependencies
- #1289, construct HTable at cluster side
- #1288: upgraded to vis 4.7.0 and optimized redraw

gearpump-0.4.2
==============
Change logs:
--------------------
 - #1217, Remove unnecessary dependencies from project core
 - #1249, separate classpath for different daemon tools
 - #1254, Add error reporting service and UI
 - #1251, refine the build package layout.
 - #1253, Partitioner instance is wrongly shared by multiple tasks
 - #1223: stalling status might not be updated in expected way
 - #1257, return error information when rest api failed.
 - #1258: support filter metrics
 - #1245, Replace processor won't work for data source
 - #1267, print services help into to console
 - #1269: could not specify transit time (2) improved time picker select behavior
 - #1241 shade guava, gs-collections and codahale-metric
 - #1275, fix HealthChecker
 - #1273, refine the metrics UI
 - #1270, add flow control for metrics data
 - #1281, make Processor ReferenceEqual=
 - #1244 simplify Build.scala

gearpump-0.4.1
==============  

Change logs:
--------------------
 - #1175 refactor dsl source and sink to remove hbase/kafka dependencies.
 - #1154: allow user to submit app by UI
 - #1165, fix random UT failures, avoid create new process in UT
 - #1166, throw exception when submit application failed. fix #1151, reduce the memory footprint of each Task
 - #1098, decouple KafkaStorage from KafkaSource
 - #1189 remove unnecessary dependency
 - #1192, fix potential message loss exception in ExpressTransport
 - #1191 change Kryo's instantiator strategy, add fallback strategy when serialization fails.
 - #1156: (1) ui supports replace processor (2) network graph would not be destroyed (3) changed dropdown menu look and feel (4) updated js libraries
 - #1208 zookeeper.connect is being overridden to localhost:2181
 - #1210, fix kafka examples

gearpump-0.4
===================
Highlights:
----------------
 1. Better YARN support, and error handling.
 2. UI allow user to submit a application directly
 3. Split framework lib with application lib, to reduce class path pollution(ongoing). (#1017)
 4. Exactly once message processing API (#6).
 5. Improved Data Connector with Kafka, and Hbase. (#1012)
 6. Dynamic DAG(#101). Which allow user to replace a computation processor(e.g. Change the parallelism, or change to upgraded implementation Task class)

Change logs:
-------------------- 
 - #1154: UI, allow user to submit application jar in UI
 - #1162: UI Backend, Rest backend cannot resume connection with master after master restart
 - #1159: memory leak in worker thread pool.
 - #1157: refactor rest interface and UT
 - #1151: reduce the memory footprint when there are thousands of tasks
 - #1149: Shell tools printed too much detail on console
 - #1146: actor hungry when worker use block-io to wait response from FileServer.
 - #1088: move hbase code to external/
 - #1140: pass app name to task
 - #1017: Split daemon dependencies with core dependencies
 - #1144: fix out of memory when trying to scale gearpump to 2000 task on a 2 core machine
 - #995: Command line parser should be able to fall back  to MAIN-CLASS definition in MANIFEST.IN when mainClass is not specified in command line options.
 - #1136: fix a dead-lock when shutting down actor system.
 - #101: feature dynamic dag, which allows user to change the running topology in the fly.
 - #1115: design better interface for kafka module 
 - #1123: UI, able to restart a running application via dashboard
  - #1037: When user create daemon logs like ui.log in the running, we should be able to recreate a new log file.
 - #1106: cache opensource webfont lato (831kb in total) locally so that there is no error when no internet access
 - #1097: appdag should adapt to window size automatically.
 - #1096: (1) echart would not response resizing (2) metric selector did not work due to angularjs 1.4 breaking change (3) tested and updated other js libraries
 - #1094: service unreachable message will be shown when health check fails
 - #1066: AppSubmitter should not return 0 when error occurred
 - #1056: fix yarn client, to be able to submit applications to master when running in YARN
 - #1083: fix KafkaWordCount example
 - #1080: [UI] uses moving average 1 minute instead of mean rate. As the meanrate changes much slower.
 - #1017, split the lib directory into daemon, and lib. So that user application can have less dependencies.
 - #1067. [YARN]Changing visibility of yarn resources
 - #1064: UI. edge data was not constructed correctly
 - #1060: Add default kafka message decoder
 - #1012, add Source and Sink API
 - #1044 print worker hostname in master log when registering
 - #922: UI. get version by rest api
 - #1025: master is binding to incorrect port when deployed on Yarn
 - #964: #966. Use FSM to manage state in YarnApplicationMaster. Adding missing UT.
 - #1010, Simplify the travis build so that it take less time.

gearpump-0.3.7
===================

Highlight: experimental transactional support

Change list
-----------------
 - #1006, revert the display clock to original version
 - #1004, fix transactional state compile failure
 - #6, add transaction api
 - #902, delete kafka topic on close
 - #826: upgraded to visjs 4.1.0-develop
 - #924, show application name and status on "gear info"
 - #981, add prompt for ClassNotFoundException 

gearpump-0.3.6
=====================
Change list
------------------
 - #977, speedup the UT by avoiding creating multiple sub process JVMs.
 - #974, Remove unnecessary MasterProxy creation in unit test
 - #969 Tests for examples create a test harness per test
 - #968, update Codecov upload method
 - #960, Services Specs do not terminate ClockService 
 - #959, LOG in TimeoutScheduler causes JVM exit 
 - #935 improve the application clock 
 - #659, remove kafka integration test 
 - #947 optimize checkMessage performance in TaskActor
 - #945, [NPE regression] Partitioner is null 
 - #941, allow user to define custom partitioner by REST 
 - #890: add cloudera manager integration support for gearpump 
 - #928 continue to improve the performance of taskActor.allowSendingMoreMessages 
 - #936 bumping up version of sbt-scoverage plugin 
 - #934, allow user to define uid for edge partitioner. 
 - #928 improve the allowSendingMsg performance 
 - #926: previous restcall should be dropped if the page is destroyed

gearpump-0.3.5
=====================
Change list
------------------
 - #729 remove argument '-master' in YARN service and documents.
 - #759, fix storm connector bug due to unstable topology sort of DAG
 - #775, fix netty config
 - #778, log improvements
 - #781 when launching lots of tasks, the application failed to transfer message across hosts 
 - #782, a) add wildcard match to return metrics(support glob char . and *), b) add diagnosis message if the clock stop advancing
 - #786, Read user config from classpath, the appmaster/executor wil use the dynamic user config
 - #773: skew chart will show relative skew
 - #790, 1) return detail task data in appmaster REST. 2) bind executor id with executor system id
 - #795 TaskScheduleImpl'bug when executor failed
 - #799 Getting 2.10 cross build working
 - #802 add process id and host name in executor log file
 - #803: (1) websocket is by default not preferred (2) throughput should be added as sum not mean (3) changed input/output message to sink/source processor receive/send throughput
 - #805, metrics rest service should return latest metrics received
 - #684 - setting -Xmx for master and worker when running on Yarn This will prevent JVMs from growing above limits and get killed by Yarn
 - #796: (1) added executor info (2) fixed skew chart issue for the first node
 - #801, add config service for master and worker.
 - #741 add a example transport use case
 - #814, expose TaskActor.minClock through TaskContext
 - #741 refine example
 - #817 split examples jar into multiple jars
 - #824, allow to use default partitioner when defining a DAG
 - #829, add some handy operator like groupByKey, sum, for KV Stream
 - #831: uses pagination control to speedup table rendering
 - #816: use multi-select control to select tasks
 - #840: task charts data were incorrect
 - #844, expose upstream minclock
 - #204, page rank demo code
 - #846, support more anyVals in user config
 - #843, Can't put custom user config in application.conf
 - #849, set default hostname to 127.0.0.1 in UT
 - #851, JVM not exited when there is exception due to akka create non-daemon threads
 - #854, fix storm connector performance
 - #856, Service launch failed
 - #853, fix resource leak(thread not closed, process not killed in UT. Also increase the PermGen size to avoid Permgen OOM.
 - #859, random UT fail due to akka bug, "akka cluster deadlock when initializing"
 - #865, Change the default timeout setting in akka test expectMsg
 - #871, Add explicit error log for kryo serialization exception
 - #877: source node and sink node were not calculated correctly.
 - #874, [TaskActor] task onStart should be called after the network transport layer is ready
 - #879: split metrics into different views and changed tooltip control
 - #881: diverse issues of skew charts and made tooltip nice
 - #876: clock is updated every second-
 - #885: wrong application clock in some case
 - #53, rest interface to submit a dag by JSON representation
 - #887, add a rest to get stalling tasks
 - #801: added download links for configurations-
 - #742 add a rest to get Gearpump version
 - #898, Downgrade akka version from 2.3.9 to 2.3.6
 - #900, Use gearpump.hostname by default=
 - #719 add Kafka Source and HBase Sink for dsl
 - #905: Upgrade sbt-pack from 0.6.8 to 0.6.9
 - #602: dashboard will freeze when server is unreachable
 - #907: calculate application clock update frequency for a 30 second time frame
 - #919: vis.js's version was not updated 

gearpump-0.3.4
====================
Change List:
----------------
 - #768, Serious performance degrade of ui server on windows
 - #765, improve the graph type inference so we don't need to set template argument type explicitly

gearpump-0.3.3
====================
Change List:
----------------
 - #716, Refine the user interface. improve the user interface, like Application, Processor
 - #755, fix Build breakage, 
 - #729, remove argument '-master' in command line option, use gear.conf instead.
 - #713, provide an option to read from beginning of a topic 
 - #746, support state clock for task so that we can retrieve the state timestamp
 - #744: fix several metrics issues
 - #638, Use Subscription to link two processor
 - #662, [UI] added processor  details tab
 - #735, [yarn]Launch UI in the same container of Yarn AppMaster container.
 - #732: [UI]add more charts and add more metrics to dag
 - #731 rename TaskDescription to ProcessorDescription
 - #708, fix storm connector config classpath 
 - #722: [UI]use different color and opacity for edges
 - #708, allow user to pass in a customized storm config
 - #709: [UI]npe when streaming dag is not initialized
 - #704, DAG processor name is "undefined" if "description` field of TaskDescription is not defined
 - #706, Remove example jars from gearpump built-in classpath.
 - #701 add a HBase sink
 - #28, add an experiment module to support a very basic flatmap dsl
 - #666, add UI for stock crawler example
 - #691: [UI] fix metrics
 - #680, add a service in appmaster to support query of task actorRef
 - #210, allow easier remote debugging executor process
 - #666, add a stock index crawler example,
 - #658 make config of Gearpump on Yarn configurable
 - #676, add a storm connector to allow user to run arbitrary storm jar
 - #657, remove unnecessary yarn deps
 - #672, extend Task to support unmanaged messages so that every task can serve as full functional service
 - #670, fix yarn application path and log path
 - #665, Add scheduleOnce interface in TaskContext

gearpump-0.3.2
====================
Change List:
 - #654, Use yarn to distribute whole gearpump package instead of jars
 - #631, remove unnecessary storm dependencies
 - #652, log conflict between slf4j and log4j
 - #652, log is muted when running on yarn
 - #650, remove logback classic slf4j binding from classpath
 - #648, yarn unable to start worker
 - #27, Integrate YARN into scheduler
 - #643: metrics tables are now sortable
 - #639, fix parallelism is 0 on GlobalGrouping
 - #636, fix FieldsGroupingPartitioner
 - #629 - query backend for actual websocket address 
 - #634: create websocket can be failed when url is undefined
 - #415, support storm connector
 - #613, Show metrics charts in application's detail page
 - #546 add a rest api to query WebSocket url
 - #624, add description field to TaskDescription
 - #434 add api/v1.0 prefix for all rest services
 - #618 fix no data returned when call Metrics rest
 - #607, bump up kafka version to 0.8.2.1
 - #615, Incorrect Dag edge width
 - #608 increase the maximum frame size of Akka
 - #611: dag looks more elegant
 
gearpump-0.3.1
====================
Change List:
- #591, (1) added metrics to application detail page (2) periodically update page contents without pressing refresh (3) replaced angular-dashboard-framework with bootstrap + angular
- #600, Config API should return all config under section "gearpump"
- #597, by default, app wil run for ever except you kill it explicitly.
- #595, use smaller metrics interval
- #417, update READ.ME and refactor DistributedShell
- #388, catch netty channel close exception and warn
- #589, change applicationData's timestamp to 24-h format
- #417, deploy a service across the cluster
- #568, enable history metrics service
- #584, KafkaOffsetManager should only stores one offset per timestamp 
- #562 fix AppMaster and Executor restart infinitely
- #576, Add processor level for REST returned DAG, so that the UI can render the DAG correctly.
- #568, [REST] add history metrics service in backend 
- #571 AppMaster failed to recover
- #569, dag cannot be rendered
- #566, a) add rest service to shutdown an application b) add a rest service to provide app configuration
- #564, REST should return more data for Application information
- #561, add more task metrics
- #558, [REST]Add missing "name" field for metric Histogram
- #556, Use "Processor" to replace taskGroup in source code
- #555, DAG data returned should contains processor Id
- #544, (1) dashboard will now request appmaster details only once 2) visdag is no longer a widget of adf (3) reduced animation of visdag
- #526, Kafka tests are failing in master branch
- #467, Expose codahale metrics by rest service
- #526, temporary disabled kafka examples to make build pass
- #513, Several remain UI issues in new dashboard, like version tag in dashboard
- #516, Travis failed to deploy the binary to github release

gearpump-0.3.0-rc1
====================
Change List:
---------------
 - #510, add log directory for UI server
 - #485, retain inactive application history in Master
 - #504, 1) AppMaster return more detailed application runtime information. 2) fix a worker bug when returning executors which run on worker. 
 - #422, [UI] show the number of executors (2) changed layout of application page
 - #417, add a experiment module to distribute a zip file to different machines
 - #502, fix KafkaStorage loading data for async kafka consumer
 - #422, [UI] (1) added home directory in UI (2) removed millis from duration 3) updated dag control height
 - #476, fix worker and master log path format in rest service
 - #498, worker rest data is not updated in UI
 - #397, move distributed shell from experiments to examples folder
 - #493 add implicit sender so that the Task can send itself messages[work around]
 - #427, use new kafka producer in kafka 0.8.2
 - #422, added cluster page to show master and worker information
 - #489, make the worker rest information easier to parse
 - #202, Add a default serializer for all kinds of messages
 - #477, REST Workers should return more information
 - #456, uses webjars to serve visjs 3.10.0
 - #483, upgrade visdag to 3.10 because widget does not repaint correctly when a node is moved
 - #473, Use webjars with spray support instead of bower to serve static resources
 - #477, return more data for rest call workers/
 - #474, fix rest service UT test fail.
 - #479, publish test jar as artifacts
 - #419, Reorder the application log by master startup timestamp
 - #456, Use visdag to render the graph DAG
 - #464, Travis bower integration
 - #394, fix kafka producer hang issue
 - #468, For test code, the ClockService will throw exception when the DAG is not defined
 - #465, fix appname prefix bug
 - #461, AppMasterSpec and WorkServiceSpec UT are failing 
 - #270, Create a force-direct dag 
 - #453, Add rest service to serve master info 
 - #423, refactor task by separating TaskActor and Task
 - #422, add worker rest api
 - #449: avoid load external resource by removing all CDN external links
 - #397 refactor distributed shell by using new Cluster API
 - #441, ui-portal is failed to build because of spray version conflict
 - #430 use application name as unique identifier for an application
 - #440, moved dashboard code from conf to service/dashboard
 - #402, refactor task manager
 - #280, Add websockets to REST api
 - #269, Define UI Dashboard structure
 - #406, custom executor jvm config in gear.conf is not effective.
 - #394, fix ActorSystemBooter process not shut down after application finishes
 - #412, add version.sbt 
 - #410 Add sbt-eclipse plugin and wiki for how to build gearpump on eclipse
 - #408, handle Ctrl+C(sigint) gracefully.
 - #396, bump up kafka version to 0.8.2.0
 - #398, Expose more metrics info
 - #389, fix kafka fetch thread bug 
 - #386 UT fail due to unclosed sequence file
 - #370, refactor streaming appmaster
 - #358, use uPickle for REST Service
 - #372, fix DAG subgraph build and more Graph UT
 - #377, fix KafkaSource.pull performance due to the List.append is not having good performance
 - #378, construct the serializer explicitly, instead of implicitly via the kryo serializer akka extension
 - #380, set the context class loader as the URL class loader for ActorSystem.

gearpump-0.2.3
====================
Change List:
---------------
 - #333, KafkaUtilSpec causes out of memory on travis
 - #335, #359, Enable auto-deployment to sonatype
 - #299, Some UT may fail randomly, most because of the expectMsg time out
 - #338, fix kafka leader not available exception
 - #349, scoverage dependencies get into snapshot build binaries.
 - #352, add RollingCountSpec
 - #356, User's application.conf can not be loaded due to empty config.
 - #373, add more restrict checks for warning, deprecation and feature

gearpump-0.2.2
====================
Change List:
-----------------
 - #327 fix 0.2.1 build error
 - #308 add another dag example project
 - #330 Allow user to output the metrics to log file besides graphite

gearpump-0.2.1
====================

Change List:
-----------------
 - #244, add more UT, 
 - #250, refactor kafka implementations
 - #301, fix UserConfig ClassNotFoundException
 - #306, ClassNotFound for customized Application type
 - #299 fix SeqFileStreamProcessorSpec
 - #320 fix dead lock in StreamTestUtil.createEchoTaskActor
 - #317, allow user to customize the akka system config for appmaster
 - #244, add KafkaUtilSpec and kafka integration test

gearpump-0.2
=========================

Highlights:
-----------------
 - Published a tech paper about the design on https://typesafe.com/blog/gearpump-real-time-streaming-engine-using-akka
 - UT coverage rate to 70%
 - Add support for general replay-able data source to support at least once delivery. 
 - More robust streaming. Be resilient to message loss, message duplication, and zombie processes. 
 - Refactor Kafka data source for at least once delivery.
 - Support general applications besides streaming, add an experimental distributedshell application under experiments/.
 - Re-defined the AppMaster, and Task interface, It is much easier to write an application now.
 - Support submitting and distributing large applications jars.
 - Add CI tool, nightly build, code coverage, and defined a formal commit guideline.

Change list:
-------------------
 - #274 AppMaster cannot connect to worker if there are multiple interface on one machine 
 - #272 Too many dead log messages in the log
 - #266 Kafka grouper conf is incorrect 
 - #259 fix stream replay api and impl
 - #245 jacoco conflict with codecov
 - #244 Add more unit test for better test coverage
 - #242 Add application submitter username so that we can separate the logs for different user
 - #239 REST AppMasterService test failed
 - #237 Add more information in log line
 - #233 Add TIMEOUT for interactive messages between two parties
 - #230 Executor fails to connect with AppMaster when in a multiple NIC environment
 - #229  Add a default cluster config under conf/
 - #226 return error message to user if not enough slots
 - #225 Gearpump logging application logs to different streams(and to persistent storage)
 - #222 TimeStampFilter implementation is wrong
 - #221 AppMastersDataRequest, AppMasterDataRequest and AppMasterDataDetailRequest should return information about failed appmaster attempts
 - #217 Write a small custom AppMaster example, which can run distributed shell.
 - #216 Support large application jars
 - #215 Improve the API and configs so it more easy to write and submit a new application.
 - #213 Add documents about how we do benchmark
 - #212 when network partition happen there maybe zombie tasks still sending messages for a while
 - #208 Support long-running applications
 - #196 When AppMasterStarter fails to load a class, the whole Gearpump cluster crash
 - #191 Add docs for all examples
 - #184 When packing example to a uber jar, should not include core and streaming jars
 - #176  Fix NPE for REST /appmaster/0?detail=true when no appmasters have launched
 - #169 Convert REST CustomSerializers to extend DefaultJsonProtocol
 - #162 version conflicts between dependencies of sub projects  bug
 - #148 Revert code to be Java 6 compatible
 - #145 Add instructions document for Gearpump commit process
 - #138 Update ReadMe.md project description
 - #135 Add travis build|passing status icon to README.md
 - #130 AppMaster, TaskActor class references should not be explicitly referenced in SubmitApplication and TaskDescription  - messages
 - #127 Document how to run coverage reports, fix sigar exception seen during tests.
 - #117 Fix style and code warnings, use slf4j where appropriate  
 - #116 Add unit tests to gearpump-core
 - #115 Setup travis CI and codecov.io for Gearpump
 - #112 Break up examples into separate projects as prerequisite to #100
 - #110 Netty Java code cleanup
 - #108 Spout and Bolt classes should be renamed
 - #106 Add unit tests for REST api  
 - #104 ActorInitializationException while running wordCount in local mode
 - #103 Build error, unable to resolve akka-data-replication
