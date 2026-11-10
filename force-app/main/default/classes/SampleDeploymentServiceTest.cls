@isTest
private class SampleDeploymentServiceTest {
    @isTest
    static void testGetStatus() {
        Test.startTest();
        String result = SampleDeploymentService.getStatus();
        Test.stopTest();
        System.assertEquals('Ready for deployment', result, 'Status string should match expected value.');
    }
}