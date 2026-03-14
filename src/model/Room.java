package model;

public class Room {

    private String roomId;
    private String departmentId;
    private String roomName;
    private String description;

    public Room() {
    }

    public Room(String roomId, String departmentId, String roomName, String description) {
        this.roomId = roomId;
        this.departmentId = departmentId;
        this.roomName = roomName;
        this.description = description;
    }

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId;
    }

    public String getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(String departmentId) {
        this.departmentId = departmentId;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}