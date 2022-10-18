
    @Test
    public void TC787() {
        //Verify user can navigate to the sign up page from the login model
        String LOGIN_Text = "Login";

        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        onView(withText(LOGIN_Text)).perform(click());

        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        onView(withText("LoginScreen-SigUp-Link")).perform(click());

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        onView(withText("LoginScreen-SigUp-Link")).check(matches(isDisplayed()));
    }
