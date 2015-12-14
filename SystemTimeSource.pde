class SystemTimeSource implements ITimeSource
{
  LocalDateTime getDateTime()
  {
    return LocalDateTime.now();
  }
}