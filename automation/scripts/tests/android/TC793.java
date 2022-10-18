
    @Test
    public void TC793() {
        //moved over
        //Verify error message when user attempts login with incorrect credentials
        String Error_Text = "That email and password combination is not valid.";
        Helpers.login("asd@asd.com", Helpers.fuboSBPasswordGenerator());
        onView(withText(Error_Text)).check(matches(isDisplayed()));
    }
