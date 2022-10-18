
    @Test
    public void TC785() {
        //verify login button is not clickable if user only passes email
        Helpers.loginWithoutSubmitting("asd@asd.com", "");
        onView(withText("Login")).check(matches(not(isClickable())));
    }
