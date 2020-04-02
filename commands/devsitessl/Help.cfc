/*
 * A Help file for the devsitessl module
 */
component {

    /*
     * The entry point to the module
     */
    void function run() {
        print.line(
            'This tool is meant to be used to install quick SSL certifications for local development environments.'
        );
        print.line(
            '*** IT IS NOT MEANT FOR PRODUCTION AND PROBABLY WILL NOT WORK AS SSL FOR ANYONE OUTSIDE YOUR DEV TEAM.
        NO ONE WHO IS ASSOCIATED WITH THIS MODULE IN ANYWAY ASSUMES ANY RESPONSIBILITY FOR YOUR SITES, THEIR SECURITY OR ANYTHING ELSE.'
        );
        print.line('');
        print.line(
            '
            Simply put, there are two certificates needed to create a functional SSL certificate for your development sites.
            1. A site specific certificate and key (2 files) which site in your dev sites and provide the encryption. These certifictions need to be an ''Authority organization''.
            2. The ''Authority'' certificate which tells your system that the Authority that created the site specific certs is, in fact, legitmate.
            This is possible because these sites are only meant to be internal and because no one outside of your organization will have the ''Authority'' certificates.

            *** THIS TECHNIQUE CAN NOT BE USED ON PRODUCTION SITES BOTH FROM ETHICAL AS WELL AS TECHNICAL REASONS ***

            This module is based on a article here:https://www.freecodecamp.org/news/how-to-get-https-working-on-your-local-development-environment-in-5-minutes-7af615770eec/
        '
        );
    }

}
