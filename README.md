# SaveToDB Examples for Oracle Database

SaveToDB examples show various features of the applications built with Oracle Database and the following client apps:

- [SaveToDB add-in for Microsoft Excel](https://www.savetodb.com/savetodb.htm)
- [DBEdit for Windows](https://www.savetodb.com/dbedit.htm)
- [DBGate for Windows and Linux](https://www.savetodb.com/dbgate.htm)
- [ODataDB for Windows and Linux](https://www.savetodb.com/odatadb.htm)

To try examples with Excel, download the [SaveToDB SDK](https://www.savetodb.com/download.htm) which includes the source codes and workbooks.

Some samples have no configuration and show the features from the box.

Other samples have the configured features. Refer to the [Developer Guide](https://www.savetodb.com/dev-guide/getting-started.htm) for details.

Such samples use one or more frameworks:

- [SaveToDB Framework for Oracle Database](https://github.com/savetodb/savetodb-framework-for-oracle-database)
- [SaveToDB Framework Extension for Oracle Database](https://github.com/savetodb/savetodb-framework-extension-for-oracle-database)

Examples may contain preconfigured users defined in application-grants.sql files.

[passwords.txt](passwords.txt) contains logins and passwords for users of all examples.


## Manual installation, update, and uninstallation

### Installation

To install the example, execute the following files from the example folder in the following order:

1. savetodb-framework-install.sql (if exists)
2. savetodb-framework-extension-install.sql (if exists)
3. application-install.sql
4. application-grants.sql

Omit SaveToDB framework files if you already installed them with another example.

SaveToDB Framework files, except for savetodb-framework-install.sql, are optional anyway.

You may check the actual files in the install.lst file.

### Update

SaveToDB samples do not support updating. However, you may update SaveToDB frameworks separately.

### Uninstallation

To remove the example, execute the following files from the example folder in the following order:

1. application-remove.sql
2. savetodb-framework-extension-remove.sql (if exists)
3. savetodb-framework-remove.sql (if exists)

You may check the actual files in the remove.lst file.

Remove SaveToDB frameworks with the latest uninstalled example only.


## Installation and uninstallation with DBSetup

DBSetup is a free command-line tool to automate install and uninstall operations.

It is shipped with [SaveToDB SDKs](https://www.savetodb.com/download.htm), [SaveToDB add-in](https://www.savetodb.com/savetodb.htm), and [DBEdit](https://www.savetodb.com/dbedit.htm)..

We recommend installing it with gsqlcmd, another free useful tool for database developers.

To install or uninstall the example, edit the setup connection string in the gsqlcmd.exe.config file and run `dbsetup` in Windows or `dotnet dbsetup` in Linux. Then follow command-line instructions.


## License

The SaveToDB examples are licensed under the MIT license.
