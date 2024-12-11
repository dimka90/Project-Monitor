//SPDX-License-identifier: MIT

pragma solidity ^0.8.26;
import "forge-std/console.sol";
contract Procurement{
 // Define roles: Contractors, Whistleblowers, and Government Agency
enum UserRole { None, Contractor, Whistleblower, Agency }
enum ProjectStatus { NotStarted, InProgress, Completed, Canceled }

event CreateContractor(string,address,uint);
event CreateProject(string projectDescription,uint projectId,address contractorName,address agencyAddress);

struct Contractor{

    string companyName;
    uint registrationNumber;
    uint taxIdenticationNumber;
    string physicalAddress;
    address owner;
    string addressImageCid;
    string companyUploadedCid;
}

struct CompletedProjects{
    uint projectId;
    string projectDescription;
    string projectImagecid;
    bool status;

}

struct Milestone{
    uint milestoneId;
    string description;
    bool completed;
    uint paymentAmount;
    uint dueDate;
    uint startDate;
}

struct Project {
    uint256 projectId;
    string description;
    uint256 budget;
    uint256 currentBalance;
    address contractorAddress;
    bool completed;
    uint startDate;
    uint endDate;
    Milestone[] mileStone;
}
uint256 projectId = 1;

// Data structures for data storage
mapping(uint256 => Project) public projects; 
mapping(address => uint256[]) public contractorProjects;
mapping(uint256 projectId=> Milestone[]) public projectMilestones;
mapping(uint256 => Contractor) public contractor;
Contractor[] public contractors;
uint milestoneId;

function createProject(
    string memory _description,
    uint256 _budget,
    uint256 _currentBalance,
    address _contractorAddress,
    uint _startdate,
    uint _endate,
    Milestone[] calldata _milestones
) external {
require(_milestones.length > 0, "Milestone is require");

Project storage newProject = projects[projectId];
newProject.projectId = projectId;
newProject.description = _description;
newProject.budget = _budget;
newProject.currentBalance = _currentBalance;
newProject.contractorAddress = _contractorAddress;
newProject.completed = false;
newProject.startDate = _startdate;
newProject.endDate = _endate;

for (uint i; i< _milestones.length;i++){
newProject.mileStone.push(
    Milestone({
milestoneId: milestoneId,
description:_milestones[i].description,
completed: false,
paymentAmount:_milestones[i].paymentAmount,
dueDate: _milestones[i].dueDate,
startDate: _milestones[i].startDate
    }));
}
// Append to list of contractors project

contractorProjects[_contractorAddress].push(projectId);

emit CreateProject(
_description,
projectId,
_contractorAddress,
msg.sender
);
projectId++;

}

// contractors information

function createContractor(
   
    string memory _companyName,
    uint _registrationNumber,
    uint _taxIdenticationNumber,
    string memory _physicalAddress,
    string memory _addressImageCid,
    string memory _companyUploadedCid
) external {
    // work on this 
    require(contractor[_registrationNumber].registrationNumber != _registrationNumber,"Contractor already exist");
 // validate the user address
    contractors.push(
        Contractor({
            companyName: _companyName,
            registrationNumber: _registrationNumber,
            taxIdenticationNumber: _taxIdenticationNumber,
            physicalAddress: _physicalAddress,
            owner:msg.sender,
            addressImageCid: _addressImageCid,
            companyUploadedCid: _companyUploadedCid
        })
    );
emit CreateContractor(_companyName, msg.sender, _registrationNumber);

}


function submitCompletedProject(
    uint _projectId,
    string memory _projectDescription,
    string memory  _projectImagecid  
) external{



}
// Getters functions

function getAllContractors() external view returns(Contractor[] memory) 
{
    return  contractors;
}

function getContractor(address _contractorAddress) external view  returns(Contractor memory ){
    require(_contractorAddress != address(0), "Address can't be zero");
    require(contractors.length>0, "No Contractor Onboard");
    for (uint i; i<contractors.length; i++){

        if (contractors[i].owner == _contractorAddress){
            return contractors[i];
        }

    }
    // Contractor not found
    return Contractor({
        companyName: "",
        registrationNumber: 0,
        taxIdenticationNumber: 0,
        physicalAddress: "",
        owner: address(0),
        addressImageCid: "",
        companyUploadedCid: ""
    });
}


function getContractorsProject(address _address) view external returns(Project[] memory){

    uint[] memory projectIds = contractorProjects[_address];
    uint count=0;

    for(uint i; i<projectIds.length; i++){
        count++;
    }
    Project[] memory _projects =  new Project[](count);
    uint index = 0;
    for(uint i; i<projectIds.length; i++){
         uint _projectId = projectIds[i];
        _projects[index] = projects[_projectId];
        index++;
    }

return _projects;

}

function getProjectMillstones(uint _projectId)  external view returns(Milestone[] memory) { 

    return projectMilestones[_projectId];

}
function getProject(uint _projectId) external view returns(Project memory){
return projects[_projectId];

}


// Government agency 

function createAgency () external{

}
}
//source->syn