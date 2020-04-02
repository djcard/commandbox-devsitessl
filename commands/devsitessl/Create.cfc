/*
 * Walks through a process and displays the commands to create OpenSSL certifications
 */

component {

    /*
     * The entry point for the command
     * @domainname The local site for the certificate being made
     * @destination Where do you want to the certificate and supporting files written (the workbench)
     * @rootCertificateName If there is already a root certificate created, where is it located
     */
    void function run(required string domainname, string destination = getcwd(), string rootCertificateName = '') {
        initialVerbage();
        confirm('When ready, hit any key');
        if (arguments.rootcertificateName eq '') {
            print.line('To create the Root Certificate');
            print.line('Open a terminal window, run the next two lines, one after the other');
            generateRootKey(destination);
            confirm('When ready, hit Enter to Continue');
            generateRootCertificate(destination);
            var opencertManager = ask('Do you want to install the certificate now? [y/n]: ');
            if (opencertManager eq 'y') {
                importForWindows();
            }
        }
        confirm('When ready, hit Enter to Continue');
        rawcsrcnfData(domainname, destination);
        createv3(domainname, destination);
        createserverkey(domainname, destination);
        confirm('When ready, hit Enter to Continue');
        createservercert(domainname, destination);
        confirm('When ready, hit Enter to Continue');
        wrapup();
    }

    /*
     * Displays preliminary info
     */
    void function initialVerbage() {
        print.line(
            'This tool is meant to be used to install quick SSL certifications for local development environments.'
        );
        print.line(
            '*** IT IS NOT MEANT FOR PRODUCTION AND PROBABLY WILL NOT WORK AS SSL FOR ANYONE OUTSIDE YOUR DEV TEAM. ***'
        );
        print.line(
            'NO ONE WHO IS ASSOCIATED WITH THIS MODULE IN ANYWAY ASSUMES ANY RESPONSIBILITY FOR YOUR SITES, THEIR SECURITY OR ANYTHING ELSE.'
        );
        print.line('');
        print.line(
            '
            Simply put, there are two certificates needed to create a functional SSL certificate for your development sites.
            1. A site specific certificate and key (2 files) which sit in your dev sites and provide the encryption. These certifictions need to be issued by an ''Authority organization''.
            2. The ''Authority'' certificate which tells your system that the Authority that created the site specific certs is, in fact, legitmate.
            This is possible because these sites are only meant to be internal and because no one outside of your organization will have the ''Authority'' certificates.

            *** THIS TECHNIQUE CAN NOT BE USED ON PRODUCTION SITES BOTH FROM ETHICAL AS WELL AS TECHNICAL REASONS ***

            This module is based on a article here:https://www.freecodecamp.org/news/how-to-get-https-working-on-your-local-development-environment-in-5-minutes-7af615770eec/
        '
        );
        print.line('');
        print.line('');
        print.line('Make sure that you have OpenSSL downloaded from https://www.openssl.org/');
    }

    /*
     * Displays The commands to generate the ket for the root certificate
     * @destination Where does this file get written
     */
    void function generateRootKey(string destination = '') {
        print.line('');
        print.line('');
        print.line(
            'In the first step, you''ll create the encryption key for the root certificate. You will be asked to enter and then repeat a PassPhrase. You will need to re-enter this later as well. Please remember or note it in a safe place.'
        );
        print.line('openssl genrsa -des3 -out #arguments.destination#rootCA.key 2048');
    }

    /*
     * Displays The commands to generate the root certificate
     * @destination Where does this file get written
     */
    void function generateRootCertificate(string destination = getcwd()) {
        print.line('');
        print.line('Next you''ll use the key you just made to create the actual root certificate.');
        print.line('');
        print.line(
            'openssl req -x509 -new -nodes -key #arguments.destination#rootCA.key -sha256 -days 1024 -out #destination#rootCA.pem'
        );
    }


    /*
     * The instructions for importing the root certificate for the mac
     */
    void function importForMac() {
        print.line(
            'This is taken from https://www.freecodecamp.org/news/how-to-get-https-working-on-your-local-development-environment-in-5-minutes-7af615770eec/'
        );
        print.line(
            'Before you can use the newly created Root SSL certificate to start issuing domain certificates, thereÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢s one more step. You need to to tell your Mac to trust your root certificate so all individual certificates issued by it are also trusted.
            Open Keychain Access on your Mac and go to the Certificates category in your System keychain. Once there, import the rootCA.pem using File > Import Items. Double click the imported certificate and change the ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã…â€œWhen using this certificate:ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¯Ãƒâ€šÃ‚Â¿Ãƒâ€šÃ‚Â½ dropdown to Always Trust in the Trust section.'
        );
    }

    /**
     * Gives instructions and then opens the Certificate Manager
     */
    void function importForWindows() {
        print.underscoredIndentedLine('Installing for Windows');
        print.indentedline(
            '1. Read these directions and then, when ready, open the Certificate Manager by continuing.'
        );
        print.indentedline('2. In the Certificate Manager, right click on Trusted Root Certification Authorities.');
        print.indentedline('3. Choose ALL TASKS --> IMPORT.');
        print.indentedline('4. Choose NEXT and then Browse to the ''live'' folder.');
        print.indentedline('5. Change the file type to ''All Files'' and select springboardRootCA.pem.');
        print.indentedline('6. Click NEXT to put the certificate into Trusted Root Certification Authorities.');
        print.indentedline('7. Click FINISH.');
        print.indentedline('8. IMPORTANT: Close the Certificate Manager to free up CommandBox.');
        print.indentedline('9. After the install process is over, you will need to reboot to load the certificate.');
        confirm('Open Certificate Manager by pressing any key.');
        command('!certmgr').run();
    }


    /*
     * Creates a settings file to import during the certiicate process
     * @domainname The domain for which the cert isbeing created
     * @destination Where the files for this cert are being stored (workbench)
     */
    void function rawcsrcnfData(required string domainname, string destination = getcwd()) {
        print.line('Next you''ll create a settings file for the server certificate');
        var country = ask(message = 'Country Code (i.e. US for USA):');
        var region = ask(message = 'Region / State: ');
        var city = ask(message = 'City: ');
        var org = ask(message = 'Organization:');
        var orgunit = ask(message = 'Unit: ');
        var email = ask(message = 'Email address to use (does not send email): ');
        var cnrData = '[req]#chr(10)#
            default_bits = 2048#chr(10)#
            prompt = no#chr(10)#
            default_md = sha256#chr(10)#
            distinguished_name = dn#chr(10)#

            [dn]
            C=#country##chr(10)#
            ST=#region##chr(10)#
            L=#city##chr(10)#
            O=#org##chr(10)#
            OU=#orgunit##chr(10)#
            emailAddress=#email##chr(10)#
            CN = #domainname##chr(10)#';

        fileWrite('#destination##listFirst(domainname, '.')#-server.csr.cnf', cnrData);
    }

    /*
     * Creates a v3.ext file to import during the certiicate process
     * @domainname The domain for which the cert isbeing created
     * @destination Where the files for this cert are being stored (workbench)
     */
    void function createV3(required string domainname, string destination = getcwd()) {
        var v3Data = 'authorityKeyIdentifier=keyid,issuer#chr(10)#
            basicConstraints=CA:FALSE#chr(10)#
            keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment#chr(10)#
            subjectAltName = @alt_names#chr(10)#
            #chr(10)#
            [alt_names]#chr(10)#
            DNS.1 = localhost#chr(10)#';
        fileWrite('#destination##listfirst(domainname,'.')#-v3.ext', v3Data);
    }

    /*
     * Creates the server key file for the certificate
     * @domainname The domain for which the cert isbeing created
     * @destination Where the files for this cert are being stored (workbench)
     */
    void function createServerKey(required string domainname, string destination = getcwd()) {
        print.line('');
        print.line('Now Create the server key');
        print.line(
            'openssl req -new -sha256 -nodes -out #destination##listFirst(domainname, '.')#-server.csr -newkey rsa:2048 -keyout #destination##listFirst(domainname, '.')#-server.key -config #destination##listFirst(domainname, '.')#-server.csr.cnf'
        );
    }

    /*
     * Creates the actual certificate
     * @domainname The domain for which the cert isbeing created
     * @destination Where the files for this cert are being stored (workbench)
     */
    void function createServerCert(required string domainname, string destination = getcwd()) {
        print.line('');
        print.line('Now Create the actual Server Certificate ');
        print.line(
            'openssl x509 -req -in #destination##listFirst(domainname, '.')#-server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out #destination##listFirst(domainname, '.')#-server.crt -days 500 -sha256 -extfile #destination##listFirst(domainname, '.')#-v3.ext'
        );
    }

    /*
     * Displays some final thoughts
     */
    void function wrapup() {
    }

}
