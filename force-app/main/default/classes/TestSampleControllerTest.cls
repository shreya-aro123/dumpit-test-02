@isTest
private class TestSampleControllerTest {

    @isTest
    static void testControllerExecution() {
        Test.startTest();
        TestSampleController controller = new TestSampleController();
        Test.stopTest();

        // Assert core property initialization
        System.assertEquals(
            'Test data access for Visualforce & Apex class deployment.',
            controller.welcomeMessage,
            'Welcome message should be initialized correctly.'
        );
        System.assertNotEquals(null, controller.featureStatus, 'Feature status should not be null.');
        System.assertNotEquals(null, controller.maxRetryCount, 'Max retry count should not be null.');
    }

    @isTest
    static void testControllerWithConfig() {
        Test.startTest();
        TestSampleController controller = new TestSampleController();
        Test.stopTest();

        // Verify properties remain accessible whether MDT records exist in org or not
        System.assert(controller.featureStatus != null, 'Feature status property verified.');
        System.assert(controller.maxRetryCount != null, 'Max retry count property verified.');
    }
}