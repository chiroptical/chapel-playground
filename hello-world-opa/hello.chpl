config const printLocaleName = true;

config const tasksPerLocale = 1;

coforall loc in Locales {
    on loc {
        coforall threadIndex in 0..#tasksPerLocale {
            var message = "Hello world! (from ";
            if (tasksPerLocale > 1) {
                message += "task " + threadIndex + " of " + tasksPerLocale + " on ";
            }

            message += "locale " + here.id + " of " + numLocales;
            
            if printLocaleName {
                 message += " named " + loc.name;
            }

            message += ")";

            writeln(message);            
        }
    }
}
