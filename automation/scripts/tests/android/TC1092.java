@Test
    public void TC1092() {
        //Verify a user an register to the sportsbook
        try {
            Thread.sleep(6000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        //click join text
        onView(withText("Join")).perform(click());

        //click new user button
        onView(withContentDescription("LandingScreen-SignUp-Button-Touch")).perform().click();

        //click NJ state
        onView(withText("New Jersey")).perform().click();

        //pass email
        onView(withContentDescription("SignUpScreen-Email-Input-TextInput, Type Text Here"))
            .perform(typeText("testAutomation+789@.com"), closeSoftKeyboard());

        //pass password
        onView(withContentDescription("SignUpScreen-Password-TextInput, Type Text Here"))
            .perform(typeText(HelperMethods.fuboSBPasswordGenerator()), closeSoftKeyboard());

        //clear and pass zip
        onView(withContentDescription("SignUpScreen-input-zipcode-TextInput, Type Text Here"))
            .perform().clear();

        onView(withContentDescription("SignUpScreen-input-zipcode-TextInput, Type Text Here"))
            .perform(typeText("58839"), closeSoftKeyboard());

        //click create account btn
        onView(withContentDescription("SignUpScreen-CreateAccount-Touch")).perform().click();

        //pass first name
        onView(withContentDescription("KYCScreen-input-firstName-TextInput, Type Text Here"))
            .perform(typeText("Test"), closeSoftKeyboard());

        //pass last name
        onView(withContentDescription("KYCScreen-input-lastName-TextInput, Type Text Here"))
            .perform(typeText("Automation"), closeSoftKeyboard());

        //*skip month drop down
        //*skip day drop down

        //click year drop down
        onView(withText("2022")).perform().click();
            //scroll down to a year over 21 (1990)
        onView(withText("1990")).perform(scrollTo(), click());

        //Pass house number
        onView(withContentDescription("KYCScreen-input-address-TextInput, Type Text Here"))
            .perform(typeText("12345"), closeSoftKeyboard());

        //pass street name
        onView(withContentDescription("KYCScreen-input-address2-TextInput, Type Text Here"))
            .perform(typeText("Test Avenue"), closeSoftKeyboard());

        //click city drop down
            //How to click element with no accessiblilty id or context desc.
            //click California
            
        //pass zip code
        onView(withContentDescription("KYCScreen-telephone-TextInput-TextInput, Type Text Here"))
            .perform(typeText("85884"), closeSoftKeyboard());

        //pass phone number
        onView(withContentDescription("KYCScreen-telephone-TextInput-TextInput, Type Text Here"))
            .perform(typeText(HelperMethods.generatePhoneNumber()), closeSoftKeyboard());

        //pass ssn
        onView(withContentDescription("KYCScreen-socialSecurity-TextInput-TextInput, Type Text Here"))
            .perform(typeText("8768"), closeSoftKeyboard());

        //click all three check boxes
        onView(withContentDescription("KYCScreen-checkbox-TCCheckbox-Touch")).perform().click();
        onView(withContentDescription("KYCScreen-checkbox-ageCheckbox-Touch")).perform().click();
        onView(withContentDescription("KYCScreen-checkbox-accurateCheckbox-Touch")).perform().click();

        //click Verify information button
        onView(withContentDescription("KYCScreen-Submit-Button-Touch")).perform().click();

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        
        //'cant verify user' text
        onView(withText("We couldn't verify you")).check(matches(isDisplayed()));        
    }