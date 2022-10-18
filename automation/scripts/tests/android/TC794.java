
    @Test
    public void TC794() {
        //moved over
        ///Verify login button is clickable if both input fields are sufficient
        Helpers.loginWithoutSubmitting("asd@asd.com", Helpers.fuboSBPasswordGenerator());
        onView(withContentDescription("LoginScreen-Login-Button-Touch")).check(matches(isClickable()));
    }
