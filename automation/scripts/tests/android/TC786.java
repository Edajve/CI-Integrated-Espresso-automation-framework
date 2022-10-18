
    @Test
    public void TC786() {
        //verify login button is not clickable if user only passes password
        Helpers.loginWithoutSubmitting("", Helpers.fuboSBPasswordGenerator());
        onView(withText("Login")).check(matches(not(isClickable())));
    }
