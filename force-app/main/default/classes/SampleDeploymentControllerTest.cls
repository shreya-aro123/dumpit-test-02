@isTest
private class SampleDeploymentControllerTest {
    @isTest
    static void testGetDeploymentStatus() {
        Test.startTest();
        String status = SampleDeploymentController.getDeploymentStatus();
        Test.stopTest();
        
        System.assertEquals('Deployment Test Successful', status, 'Status string should match expected value.');
    }
}