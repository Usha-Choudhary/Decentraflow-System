
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Decentraflow System
 * @dev A simple project contract that allows creating tasks, updating status,
 *      and tracking contributors.
 */
contract Project {
    struct Task {
        string description;
        bool isCompleted;
        address creator;
    }

    Task[] public tasks;
    mapping(address => uint256) public contributions;

    event TaskCreated(uint256 taskId, string description, address creator);
    event TaskCompleted(uint256 taskId);
    event ContributionRecorded(address contributor, uint256 amount);

    /**
     * @dev Create a new task inside the project.
     * @param _description The description of the task.
     */
    function createTask(string calldata _description) external {
        tasks.push(Task(_description, false, msg.sender));
        emit TaskCreated(tasks.length - 1, _description, msg.sender);
    }

    /**
     * @dev Mark a task as completed.
     * @param _taskId The ID of the task.
     */
    function completeTask(uint256 _taskId) external {
        require(_taskId < tasks.length, "Invalid task ID");
        require(tasks[_taskId].creator == msg.sender, "Not task creator");
        require(!tasks[_taskId].isCompleted, "Task already completed");

        tasks[_taskId].isCompleted = true;
        emit TaskCompleted(_taskId);
    }

    /**
     * @dev Record contributions sent to the contract.
     */
    function contribute() external payable {
        require(msg.value > 0, "Must send ETH to contribute");

        contributions[msg.sender] += msg.value;
        emit ContributionRecorded(msg.sender, msg.value);
    }
}
